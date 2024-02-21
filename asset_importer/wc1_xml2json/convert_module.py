import json
import xml.etree.ElementTree as ET

from convert_exe import parse_coordinate


def convert_module_xml(input_xml_file: str, output_json_file: str):
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    tree = ET.ElementTree(ET.fromstring(xml_data))
    namespace = {'wc': 'http://www.wctoolbox.com/2017/WC1'}
    root = tree.getroot()

    result = {
        "MissionInfos": [],
        "MissionSpheres": [],
        "MissionFlightPaths": [],
        "MissionShips": [],
        "WingNames": [],
        "SystemNames": []

    }
    mission_info_block = root.find('.//wc:MissionInfoBlock', namespace)
    for mission_info_item in mission_info_block.findall('.//wc:MissionInfoItem', namespace):
        result["MissionInfos"].append({
            "Carrier": int(mission_info_item.attrib["Carrier"]),
            "Convoy": list(map(int, mission_info_item.attrib["Convoy"].split())),
            "InitialSphere": int(mission_info_item.attrib["Carrier"]),
            "Unknown": int(mission_info_item.attrib["Carrier"]),
            "YourShip": int(mission_info_item.attrib["Carrier"]),
        })

    mission_sphere_block = root.find('.//wc:MissionSphereBlock', namespace)
    for mission_sphere_item in mission_sphere_block.findall('.//wc:MissionSphereItem', namespace):
        mission_sphere_triggers = []
        for mission_sphere_trigger_item in mission_sphere_item.findall('.//wc:MissionSphereTriggerItem', namespace):
            mission_sphere_triggers.append({
                "Action": int(mission_sphere_trigger_item.attrib["Action"]),
                "Sphere": int(mission_sphere_trigger_item.attrib["Sphere"])
            })

        result["MissionSpheres"].append({
            "Center": parse_coordinate(mission_sphere_item.attrib["Center"]),
            "Name": mission_sphere_item.attrib["Name"],
            "Radius": int(mission_sphere_item.attrib["Radius"]),
            "ShipTypes": list(map(int, mission_sphere_item.attrib["ShipTypes"].split())),
            "Ships": list(map(int, mission_sphere_item.attrib["Ships"].split())),
            "Wave": int(mission_sphere_item.attrib["Wave"]),
            "Triggers": mission_sphere_triggers
        })

    mission_flight_path_block = root.find('.//wc:MissionFlightPathBlock', namespace)
    for mission_flight_path_item in mission_flight_path_block.findall('.//wc:MissionFlightPathItem', namespace):
        result["MissionFlightPaths"].append({
            "Objective": int(mission_flight_path_item.attrib["Objective"]),
            "Target": int(mission_flight_path_item.attrib["Target"]),
            "Text": mission_flight_path_item.attrib["Text"],
        })

    mission_ship_block = root.find('.//wc:MissionShipBlock', namespace)
    for mission_ship_item in mission_ship_block.findall('.//wc:MissionShipItem', namespace):
        result["MissionShips"].append({
            "FlightLeader": int(mission_ship_item.attrib["FlightLeader"]),
            "Formation": int(mission_ship_item.attrib["Formation"]),
            "FormationSlot": int(mission_ship_item.attrib["FormationSlot"]),
            "MissionType": int(mission_ship_item.attrib["MissionType"]),
            "Orientation": parse_coordinate(mission_ship_item.attrib["Orientation"]),
            "PilotLevel": int(mission_ship_item.attrib["PilotLevel"]),
            "Position": parse_coordinate(mission_ship_item.attrib["Position"]),
            "ShipType": int(mission_ship_item.attrib["ShipType"]),
            "Side": int(mission_ship_item.attrib["Side"]),
            "SpeedSize": int(mission_ship_item.attrib["SpeedSize"]),
            "Sphere": int(mission_ship_item.attrib["Sphere"]),
            "Status": int(mission_ship_item.attrib["Status"]),
            "Target": int(mission_ship_item.attrib["Target"]),
            "Unknown1": int(mission_ship_item.attrib["Unknown1"]),
            "Unknown3": int(mission_ship_item.attrib["Unknown3"]),
            "Unknown4": int(mission_ship_item.attrib["Unknown4"]),
            "Unknown5": int(mission_ship_item.attrib["Unknown5"]),
            "WingLeader": int(mission_ship_item.attrib["WingLeader"]),
        })

    wing_name_block = root.find('.//wc:WingNameBlock', namespace)
    for wing_name_item in wing_name_block.findall('.//wc:WingNameItem', namespace):
        result["WingNames"].append(wing_name_item.attrib["Name"] if "Name" in wing_name_item.attrib else None)

    system_name_block = root.find('.//wc:SystemNameBlock', namespace)
    for system_name_item in system_name_block.findall('.//wc:SystemNameItem', namespace):
        result["SystemNames"].append(system_name_item.attrib["Name"] if "Name" in system_name_item.attrib else None)

    with open(output_json_file, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=4)
