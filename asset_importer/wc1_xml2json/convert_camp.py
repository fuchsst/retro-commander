import json
import logging
import xml.etree.ElementTree as ET

from convert_exe import parse_coordinate


def convert_camp_xml(input_xml_file: str, output_json_file: str):
    logging.info(f"Reading {input_xml_file}")
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    # Parse the XML
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = ET.fromstring(xml_data)
    camp_blocks = {
        "StellarBackgrounds": [],
        "SeriesBranch": [],
        "BarSeating": []
    }

    for stellar_background_item in root.findall('.//wc:StellarBackgroundItem', namespace):
        stellar_background_item_dict = dict(stellar_background_item.attrib.items())
        camp_blocks["StellarBackgrounds"].append({
            "Image": int(stellar_background_item_dict["Image"]),
            "Rotation": parse_coordinate(stellar_background_item_dict["Rotation"])
        })

    for series_branch_item in root.findall('.//wc:SeriesBranchItem', namespace):
        series_branch_item_dict = dict(series_branch_item.attrib.items())
        series_branch = {
            "Cutscene": int(series_branch_item_dict["Cutscene"]),
            "FailureSeries": int(series_branch_item_dict["FailureSeries"]),
            "FailureShip": int(series_branch_item_dict["FailureShip"]),
            "MissionsActive": int(series_branch_item_dict["MissionsActive"]),
            "SuccessScore": int(series_branch_item_dict["SuccessScore"]),
            "SuccessSeries": int(series_branch_item_dict["SuccessSeries"]),
            "SuccessShip": int(series_branch_item_dict["SuccessShip"]),
            "Wingman": int(series_branch_item_dict["Wingman"]),
            "MissionScorings": []
        }

        for mission_scoring_item in series_branch_item.findall('.//wc:MissionScoringItem', namespace):
            mission_scoring_item_dict = dict(mission_scoring_item.attrib.items())
            series_branch["MissionScorings"].append({
                "FlightPathScoring": list(map(int, mission_scoring_item_dict["FlightPathScoring"].split())),
                "Medal": int(mission_scoring_item_dict["Medal"]),
                "MedalScore": int(mission_scoring_item_dict["MedalScore"])
            })

        camp_blocks["SeriesBranch"].append(series_branch)

    for bar_seating_item in root.findall('.//wc:BarSeatingItem', namespace):
        bar_seating_item_dict = dict(bar_seating_item.attrib.items())
        camp_blocks["BarSeating"].append({
            "LeftSeat": int(bar_seating_item_dict["LeftSeat"]),
            "RightSeat": int(bar_seating_item_dict["RightSeat"])
        })

    # Convert to JSON
    json_output = json.dumps(camp_blocks, indent=2)
    with open(output_json_file, "w", encoding="utf-8") as f:
        f.write(json_output)
