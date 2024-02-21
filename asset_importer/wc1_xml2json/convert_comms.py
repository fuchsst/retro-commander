import json
import logging
import xml.etree.ElementTree as ET

from convert_exe import parse_coordinate


def convert_comms_xml(input_xml_file: str, output_json_file: str):
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    pilot_messages = []

    for stellar_background_item in root.findall('.//wc:PilotMessageItem', namespace):
        stellar_background_item_dict = dict(stellar_background_item.attrib.items())
        pilot_messages.append(stellar_background_item_dict["Message"] if "Message" in stellar_background_item_dict else "")

    # Convert to JSON
    json_output = json.dumps({"PilotMessages": pilot_messages}, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)
