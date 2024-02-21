import json
import logging
import os
import subprocess
import tempfile
import uuid
import xml.etree.ElementTree as ET

from PIL import Image, ImageFilter


def parse_bounds(bounds_str: str, image_scale_factor: int):
    x1, y1, x2, y2 = map(int, bounds_str.replace(',', ' ').split())
    return {
        "x1": x1 * image_scale_factor,
        "y1": y1 * image_scale_factor,
        "x2": x2 * image_scale_factor,
        "y2": y2 * image_scale_factor
    }


def convert_vga_xml(input_xml_file: str, output_json_file: str, image_scale_factor: int):
    image_scale_factor = max(min(image_scale_factor, 4), 2)
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    image_blocks = []

    # Iterate over each ImageBlock
    for image_block in root.findall('.//wc:ImageBlock', namespace):
        block = {"Images": []}
        for item in image_block.findall('.//wc:ImageItem', namespace):
            origin = item.attrib['Origin'].split(',')
            file_path = item.attrib['file']
            # Convert file path
            block_number, item_number, new_path = _convert_filename(file_path)

            # Convert GIF to PNG with 32-bit depth including alpha channel
            original_file_path = os.path.join(os.path.dirname(input_xml_file), file_path)
            new_file_path = os.path.join(output_json_file.replace(".json", ""), block_number, item_number + ".png")
            _convert_image(new_file_path, original_file_path, image_scale_factor)
            block["Images"].append({
                "origin": {"x": int(origin[0]) * image_scale_factor, "y": int(origin[1]) * image_scale_factor},
                "file": new_path.lower()
            })
        image_blocks.append(block)

    # Convert to JSON
    json_output = json.dumps({"ImageBlocks": image_blocks}, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)


def _convert_filename(file_path):
    parts = file_path.split('-')
    block_name = parts[0].lower()
    block_number = parts[1][-3:]
    item_number = parts[2].replace(".gif", "")[-3:]
    new_path = f"{block_name}/{block_number}/{item_number}.png"
    return block_number, item_number, new_path


def _convert_image(new_file_path: str, original_file_path: str, image_scale_factor: int):
    os.makedirs(os.path.dirname(new_file_path), exist_ok=True)
    try:
        logging.info(f"Converting {original_file_path} to {new_file_path}")
        with Image.open(original_file_path) as img:
            img = img.convert("RGBA")
            result_img = scale_image(scale_image(img)).filter(ImageFilter.GaussianBlur(0.5))
            # img = hqx.hqx_scale(img, image_scale_factor)
            result_img.save(new_file_path, "PNG")
    except FileNotFoundError:
        print(f"File not found: {original_file_path}")


def scale_image(img):
    width, height = img.size

    # New size (double the original)
    new_width = width * 2
    new_height = height * 2

    # Create a new image with doubled resolution
    tmp_img = Image.new("RGBA", (new_width, new_height))

    # Populate the new image (upscale by nearest neighbor)
    pixels = img.load()
    tmp_pixels = tmp_img.load()
    for y in range(height):
        for x in range(width):
            color = pixels[x, y]
            tmp_pixels[x * 2, y * 2] = color
            tmp_pixels[x * 2 + 1, y * 2] = color
            tmp_pixels[x * 2, y * 2 + 1] = color
            tmp_pixels[x * 2 + 1, y * 2 + 1] = color

    new_img = tmp_img.copy()
    new_pixels = new_img.load()

    # Apply smoothing by checking every second pixel
    for y in range(1, new_height-1, 2):
        for x in range(1, new_width-1, 2):
            if tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y + 1] == tmp_pixels[x + 1, y]:
                new_pixels[x, y] = tmp_pixels[x + 1, y + 1]
            elif tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y + 1] == tmp_pixels[x, y]:
                new_pixels[x + 1, y] = tmp_pixels[x + 1, y + 1]
            elif tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y] == tmp_pixels[x + 1, y]:
                new_pixels[x, y + 1] = tmp_pixels[x + 1, y + 1]
            elif tmp_pixels[x, y] == tmp_pixels[x, y + 1] == tmp_pixels[x + 1, y]:
                new_pixels[x + 1, y + 1] = tmp_pixels[x, y]

    return new_img


def ai_upscale(img):
    if img.mode != 'RGBA':
        raise ValueError("Input image must be in RGBA mode.")

    # Work in a temporary directory to handle image files
    with tempfile.TemporaryDirectory() as temp_dir:
        # Prepare input paths for the RGB and alpha components
        input_rgb_path = os.path.join(temp_dir, 'input_rgb.png')
        input_alpha_path = os.path.join(temp_dir, 'input_alpha.png')

        # Split the input PIL image into RGB and alpha channels
        rgb_image = img.convert('RGB')
        alpha_image = img.getchannel('A')

        # Save the RGB and alpha components to temporary files
        rgb_image.save(input_rgb_path, format='PNG')
        alpha_image.save(input_alpha_path, format='PNG')

        # Prepare output paths for the upscaled RGB and alpha components
        upscaled_rgb_path = os.path.join(temp_dir, f'upscaled_rgb_{uuid.uuid4()}.png')
        upscaled_alpha_path = os.path.join(temp_dir, f'upscaled_alpha_{uuid.uuid4()}.png')

        # Upscale the RGB and alpha components using realesrgan-ncnn-vulkan
        subprocess.run(
            ['../Real-ESRGAN/bin/realesrgan-ncnn-vulkan.exe', '-i', input_rgb_path, '-o', upscaled_rgb_path, '-n',
             'realesrgan-x4plus-anime'], check=True)
        subprocess.run(
            ['../Real-ESRGAN/bin/realesrgan-ncnn-vulkan.exe', '-i', input_alpha_path, '-o', upscaled_alpha_path, '-n',
             'realesrgan-x4plus-anime'], check=True)

        logging.debug("Loading upscaled images ", upscaled_rgb_path)
        # Load the upscaled images back into PIL
        upscaled_rgb_img = Image.open(upscaled_rgb_path).convert('RGB')
        upscaled_alpha_img = Image.open(upscaled_alpha_path).convert('L')

        # Combine the upscaled RGB and alpha components back into an RGBA image
        upscaled_img_with_alpha = Image.merge('RGBA', upscaled_rgb_img.split() + (upscaled_alpha_img,))

        return upscaled_img_with_alpha
