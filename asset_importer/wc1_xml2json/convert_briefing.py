import json
import logging
import xml.etree.ElementTree as ET


def convert_briefing_xml(input_xml_file: str, output_json_file: str):
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    conversation_blocks = []

    # Iterate over each ImageBlock
    for conversation_block in root.findall('.//wc:ConversationBlock.Items', namespace):
        block = {"Conversations": []}
        for item in conversation_block.findall('.//wc:ConversationItem', namespace):
            conversation = {"DialogSettings": [], "Dialogs": []}
            for dialog_setting_item in item.findall('.//wc:DialogSettingItem', namespace):
                dialog_setting_item_dict = dict(dialog_setting_item.attrib.items())
                conversation["DialogSettings"].append({
                    "Background": int(dialog_setting_item_dict["Background"]),
                    "Delay": int(dialog_setting_item_dict["Delay"]),
                    "Foreground": int(dialog_setting_item_dict["Foreground"]),
                    "TextColor": int(dialog_setting_item_dict["TextColor"])
                })
            for dialog_setting_item in item.findall('.//wc:DialogItem', namespace):
                dialog_setting_item_dict = dict(dialog_setting_item.attrib.items())
                conversation["Dialogs"].append({
                    "Commands": [x for x in dialog_setting_item_dict["Commands"].split(",") if x],
                    "FacialExpressions": [x for x in dialog_setting_item_dict["FacialExpressions"].split(",") if x],
                    "LipSyncText": dialog_setting_item_dict["LipSyncText"],
                    "Text": dialog_setting_item_dict["Text"]
                })
            block["Conversations"].append(conversation)

        conversation_blocks.append(block)

    # Convert to JSON
    json_output = json.dumps({"ConversationBlocks": conversation_blocks}, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)
