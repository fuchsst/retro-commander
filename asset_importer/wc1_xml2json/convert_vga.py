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
            result_img = scale_image(scale_image(img), smooth=True)
            # img = hqx.hqx_scale(img, image_scale_factor)
            result_img.save(new_file_path, "PNG")
    except FileNotFoundError:
        print(f"File not found: {original_file_path}")


def scale_image(img, smooth: bool = False):
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
    if smooth:
        for y in range(1, new_height-1, 2):
            for x in range(1, new_width-1, 2):
                if tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y + 1] == tmp_pixels[x + 1, y]:
                    new_pixels[x, y] = tmp_pixels[x + 1, y + 1]
                elif tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y + 1] == tmp_pixels[x, y]:
                    new_pixels[x + 1, y] = tmp_pixels[x, y]
                elif tmp_pixels[x + 1, y + 1] == tmp_pixels[x, y] == tmp_pixels[x + 1, y]:
                    new_pixels[x, y + 1] = tmp_pixels[x, y]
                elif tmp_pixels[x, y] == tmp_pixels[x, y + 1] == tmp_pixels[x + 1, y]:
                    new_pixels[x + 1, y + 1] = tmp_pixels[x, y]
    else:
        new_img = tmp_img

    return new_img
