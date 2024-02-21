import json
import logging
import os
import subprocess
import tempfile
import uuid
import xml.etree.ElementTree as ET

from PIL import Image, ImageFilter

from convert_vga import scale_image


def convert_font_xml(input_xml_file: str, output_json_file: str, image_scale_factor: int):
    image_scale_factor = max(min(image_scale_factor, 4), 2)
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    image_blocks = []

    # Iterate over each ImageBlock
    for image_block in root.findall('.//wc:FontBlock', namespace):
        block = {
            "BackgroundColor":image_block.attrib["BackgroundColor"],
            "ForegroundColor":image_block.attrib["ForegroundColor"],
            "Glyphs": []
        }
        for item in image_block.findall('.//wc:GlyphItem', namespace):
            file_path = item.attrib['file'] if "file" in item.attrib else ""
            # Convert file path
            if file_path:
                parts = file_path.split('-')
                block_name = parts[0].lower()
                block_number = parts[1][-3:]
                item_number = parts[2].replace(".gif", "")[-3:]
                new_path = f"{block_name}/{block_number}/{item_number}.png"

                # Convert GIF to PNG with 32-bit depth including alpha channel
                original_file_path = os.path.join(os.path.dirname(input_xml_file), file_path)
                new_file_path = os.path.join(output_json_file.replace(".json", ""), block_number, item_number + ".png")
                os.makedirs(os.path.dirname(new_file_path), exist_ok=True)

                try:

                    logging.info(f"Converting {original_file_path} to {new_file_path}")

                    with Image.open(original_file_path) as img:
                        img = img.convert("RGBA")
                        result_img = scale_image(scale_image(img))

                        # img = hqx.hqx_scale(img, image_scale_factor)
                        result_img.save(new_file_path, "PNG")
                        block["Glyphs"].append(new_path)
                except FileNotFoundError:
                    print(f"File not found: {original_file_path}")
            else:
                block["Glyphs"].append(None)

        image_blocks.append(block)

    # Convert to JSON
    json_output = json.dumps({"ImageBlocks": image_blocks}, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)


# def scale_image(img):
#     pixels = img.load()
#     width, height = img.size
#     # Create a new image with 2x dimensions in RGBA mode
#     upscaled_img = Image.new('RGBA', (width * 2, height * 2))
#     upscaled_pixels = upscaled_img.load()
#
#     for y in range(height):
#         for x in range(width):
#             # Current pixel and neighbors, with edge handling
#             p = pixels[x, y]
#             p_left = pixels[max(x - 1, 0), y] if x > 0 else p
#             p_up = pixels[x, max(y - 1, 0)] if y > 0 else p
#             p_left_up = pixels[max(x - 1, 0), max(y - 1, 0)] if x > 0 and y > 0 else p
#             p_right = pixels[min(x + 1, width - 1), y] if x < width - 1 else p
#             p_down = pixels[x, min(y + 1, height - 1)] if y < height - 1 else p
#             p_right_down = pixels[
#                 min(x + 1, width - 1), min(y + 1, height - 1)] if x < width - 1 and y < height - 1 else p
#
#             # Correcting the mistake in referencing right_up and left_down neighbors for p2 and p3
#             p_right_up = pixels[min(x + 1, width - 1), max(y - 1, 0)] if x < width - 1 and y > 0 else p
#             p_left_down = pixels[max(x - 1, 0), min(y + 1, height - 1)] if x > 0 and y < height - 1 else p
#
#             # Calculate the new pixels including alpha
#             p1 = tuple((p[i] * 6 + p_left[i] + p_up[i] + p_left_up[i]) // 9 for i in range(4))
#             p2 = tuple((p[i] * 6 + p_right[i] + p_up[i] + p_right_up[i]) // 9 for i in range(4))
#             p3 = tuple((p[i] * 6 + p_left[i] + p_down[i] + p_left_down[i]) // 9 for i in range(4))
#             p4 = tuple((p[i] * 6 + p_right[i] + p_down[i] + p_right_down[i]) // 9 for i in range(4))
#
#             # Assign the new pixels to the upscaled image
#             upscaled_pixels[x * 2, y * 2] = p1
#             upscaled_pixels[x * 2 + 1, y * 2] = p2
#             upscaled_pixels[x * 2, y * 2 + 1] = p3
#             upscaled_pixels[x * 2 + 1, y * 2 + 1] = p4
#
#     return upscaled_img


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
