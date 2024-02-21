import json
import logging
import os
import xml.etree.ElementTree as ET

from convert_exe import parse_position
from convert_vga import _convert_image, _convert_filename


def convert_midgame_xml(input_xml_file: str, output_json_file: str, image_scale_factor: int):
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    midgame_blocks = {
        "MainImageBlock": [],
        "Cutscene0": {
            "AnimationBlock": {"SequenceGroup": -1, "SequenceSettings": [], "Sequences": []},
            "ImageBlock": [],
            "ConversationBlock": {"DialogSettings": [], "Dialogs": []},
        },
        "Cutscene1": {
            "AnimationBlock": {"SequenceGroup": -1, "SequenceSettings": [], "Sequences": []},
            "ImageBlock": [],
            "ConversationBlock": {"DialogSettings": [], "Dialogs": []},
        }
    }

    if root[0]:
        midgame_blocks["MainImageBlock"] = _convert_image_block(input_xml_file,
                                                                output_json_file,
                                                                root[0][0],
                                                                image_scale_factor)
    if root[1]:
        midgame_blocks["Cutscene0"]["AnimationBlock"]["SequenceGroup"] = int(root[1].attrib["SequenceGroup"])
        for sequence_setting_item in root[1].findall('.//wc:SequenceSettingItem', namespace):
            sequence_setting = _convert_sequence_setting_item(sequence_setting_item, image_scale_factor)
            midgame_blocks["Cutscene0"]["AnimationBlock"]["SequenceSettings"].append(sequence_setting)
        for sequence_item in root[1].findall('.//wc:SequenceItem', namespace):
            sequences = _convert_sequence_item(sequence_item)
            midgame_blocks["Cutscene0"]["AnimationBlock"]["Sequences"].append(sequences)
    if root[2]:
        midgame_blocks["Cutscene1"]["AnimationBlock"]["SequenceGroup"] = int(root[2].attrib["SequenceGroup"])
        for sequence_setting_item in root[2].findall('.//wc:SequenceSettingItem', namespace):
            sequence_setting = _convert_sequence_setting_item(sequence_setting_item, image_scale_factor)
            midgame_blocks["Cutscene1"]["AnimationBlock"]["SequenceSettings"].append(sequence_setting)
        for sequence_item in root[2].findall('.//wc:SequenceItem', namespace):
            sequences = _convert_sequence_item(sequence_item)
            midgame_blocks["Cutscene1"]["AnimationBlock"]["Sequences"].append(sequences)

    if root[3]:
        midgame_blocks["Cutscene0"]["ImageBlock"] = _convert_image_block(input_xml_file,
                                                                         output_json_file,
                                                                         root[3][0],
                                                                         image_scale_factor)
    if root[4]:
        midgame_blocks["Cutscene1"]["ImageBlock"] = _convert_image_block(input_xml_file,
                                                                         output_json_file,
                                                                         root[4][0],
                                                                         image_scale_factor)
    if root[5]:
        for dialog_setting_item in root[5].findall('.//wc:DialogSettingItem', namespace):
            dialog_setting = _convert_dialog_setting_item(dialog_setting_item, image_scale_factor)
            midgame_blocks["Cutscene0"]["ConversationBlock"]["DialogSettings"].append(dialog_setting)
        for dialog_item in root[5].findall('.//wc:DialogItem', namespace):
            dialog = _convert_dialog_item(dialog_item)
            midgame_blocks["Cutscene0"]["ConversationBlock"]["Dialogs"].append(dialog)
    if root[6]:
        for dialog_setting_item in root[6].findall('.//wc:DialogSettingItem', namespace):
            dialog_setting = _convert_dialog_setting_item(dialog_setting_item, image_scale_factor)
            midgame_blocks["Cutscene1"]["ConversationBlock"]["DialogSettings"].append(dialog_setting)
        for dialog_item in root[6].findall('.//wc:DialogItem', namespace):
            dialog = _convert_dialog_item(dialog_item)
            midgame_blocks["Cutscene1"]["ConversationBlock"]["Dialogs"].append(dialog)

    # Convert to JSON
    json_output = json.dumps(midgame_blocks, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)


def _convert_sequence_setting_item(sequence_setting_item, image_scale_factor):
    sequence_setting_item_dict = dict(sequence_setting_item.attrib.items())
    sequence_setting = {
        "Mirror": bool(int(sequence_setting_item_dict["Mirror"])),
        "Mode": int(sequence_setting_item_dict["Mode"]),
        "Position": parse_position(sequence_setting_item_dict["Position"], image_scale_factor),
        "Rotation": int(sequence_setting_item_dict["Rotation"]),
        "Scale": int(sequence_setting_item_dict["Scale"]) * image_scale_factor,
    }
    return sequence_setting


def _convert_sequence_item(sequence_item):
    commands = sequence_item.attrib["Commands"].split()
    sequence_setting = {
        "Commands": commands
    }
    return sequence_setting


def _convert_dialog_setting_item(dialog_setting_item, image_scale_factor):
    sequence_setting_item_dict = dict(dialog_setting_item.attrib.items())
    sequence_setting = {
        "Background": int(sequence_setting_item_dict["Background"]),
        "Delay": int(sequence_setting_item_dict["Delay"]),
        "Foreground": int(sequence_setting_item_dict["Foreground"]),
        "TextColor": int(sequence_setting_item_dict["TextColor"])
    }
    return sequence_setting


def _convert_dialog_item(dialog_item):
    return {
        "Commands": [x for x in dialog_item.attrib["Commands"].split(",") if x],
        "FacialExpressions": [x for x in dialog_item.attrib["FacialExpressions"].split(",") if x],
        "LipSyncText": dialog_item.attrib["LipSyncText"],
        "Text": dialog_item.attrib["Text"]
    }


def _convert_image_block(input_xml_file: str, output_json_file: str, xml_node, image_scale_factor: int):
    result = []
    for image_item in xml_node:
        image_item_dict = dict(image_item.attrib.items())
        origin = parse_position(image_item_dict["Origin"], image_scale_factor),
        file_path = image_item_dict['file']

        block_number, item_number, new_path = _convert_filename(file_path)
        original_file_path = os.path.join(os.path.dirname(input_xml_file), file_path)
        new_file_path = os.path.join(output_json_file.replace(".json", ""), block_number, item_number + ".png")
        _convert_image(new_file_path, original_file_path, image_scale_factor)
        result.append({
            "Origin": origin,
            "file": new_path
        })
    return result
