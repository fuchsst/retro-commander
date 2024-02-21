import json
import xml.etree.ElementTree as ET


def parse_bounds(bounds_str: str, image_scale_factor: int):
    x1, y1, x2, y2 = map(int, bounds_str.replace(',', ' ').split())
    return {
        "x1": x1 * image_scale_factor,
        "y1": y1 * image_scale_factor,
        "x2": x2 * image_scale_factor,
        "y2": y2 * image_scale_factor
    }


def parse_position(position_str: str, image_scale_factor: int):
    x, y = map(int, position_str.split(","))
    return {"x": x * image_scale_factor, "y": y * image_scale_factor}


def parse_coordinate(coordinate_str):
    x, y, z = map(int, coordinate_str.split(","))
    return {"x": x, "y": y, "z": z}


def convert_exe_xml(input_xml_file: str, output_json_file: str, image_scale_factor: int):
    with open(input_xml_file, "r", encoding="utf-8") as f:
        xml_data = f.read()

    tree = ET.ElementTree(ET.fromstring(xml_data))
    root = tree.getroot()

    result = {}
    for elem in list(root):
        if elem.tag.endswith("CockpitDamageLayouts"):
            result["CockpitDamageLayouts"] = []
            for elem_item in list(elem):
                for _, pos_str in elem_item.attrib.items():
                    result["CockpitDamageLayouts"].append(parse_position(pos_str, image_scale_factor))

        elif elem.tag.endswith("CockpitInstrumentLayouts"):
            result["CockpitInstrumentLayouts"] = []
            for elem_item in list(elem):
                layout_item = _convert_cockpit_instrument_layout(elem_item, image_scale_factor)

                result["CockpitInstrumentLayouts"].append(layout_item)

        elif elem.tag.endswith("CockpitMessaging"):
            result["CockpitMessaging"] = []
            for elem_item in list(elem):
                for _, pos_str in elem_item.attrib.items():
                    result["CockpitMessaging"].append(parse_position(pos_str, image_scale_factor))

        elif elem.tag.endswith("FlightFormations"):
            result["FlightFormations"] = []
            for elem_item in list(elem):
                for _, pos_str in elem_item.attrib.items():
                    result["FlightFormations"].append(parse_coordinate(pos_str))

        elif elem.tag.endswith("GameState"):
            result["GameState"] = dict(elem[0].attrib.items())

        elif elem.tag.endswith("GenericPilotIntelligenceEvents"):
            result["GenericPilotIntelligenceEvents"] = []
            for elem_item in list(elem):
                attr = dict(elem_item.attrib.items())
                result["GenericPilotIntelligenceEvents"].append(attr)

        elif elem.tag.endswith("Hardpoints"):
            result["Hardpoints"] = []
            for elem_item in list(elem):
                for _, pos_str in elem_item.attrib.items():
                    result["Hardpoints"].append(parse_coordinate(pos_str))

        elif elem.tag.endswith("Pilots"):
            result["Pilots"] = []
            for elem_item in list(elem):
                pilot = _convert_pilot(elem_item)
                result["Pilots"].append(pilot)

        elif elem.tag.endswith("ShipViewImageMappings"):
            ship_view_mapping = _convert_ship_view_mappings(elem)
            result["ShipViewImageMappings"] = ship_view_mapping

        elif elem.tag.endswith("ShipViewModifierMappings"):
            ship_view_mapping = _convert_ship_view_mappings(elem)
            result["ShipViewModifierMappings"] = ship_view_mapping

        elif elem.tag.endswith("Ships"):
            result["Ships"] = []
            for elem_item in list(elem):
                ship_item = _convert_ship(elem_item)
                result["Ships"].append(ship_item)

        elif elem.tag.endswith("Strings"):
            strings_result = _convert_exe_strings(elem)
            result["Strings"] = strings_result

        elif elem.tag.endswith("VideoDisplayWeapons"):
            result["VideoDisplayWeapons"] = []
            for elem_item in list(elem):
                for _, pos_str in elem_item.attrib.items():
                    result["VideoDisplayWeapons"].append(parse_position(pos_str, image_scale_factor))

    with open(output_json_file, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=4)


def _convert_exe_strings(elem):
    strings_result = {}
    for elem_item in list(elem[0]):
        section = elem_item.tag[elem_item.tag.find("ExeFileStrings.") + 15:]
        strings_result[section] = []
        for elem_item_entry in list(elem_item):
            str_val = elem_item_entry.attrib["Value"]
            strings_result[section].append(str_val)
    return strings_result


def _convert_ship(elem_item):
    ship_item_dict = dict(elem_item.attrib.items())
    ship_item = {
        "AngularInertia": int(ship_item_dict["AngularInertia"]),
        "Armor": list(map(int, ship_item_dict["Armor"].split())),
        "CruiseSpeed": int(ship_item_dict["CruiseSpeed"])*10, # convert to km/s
        "Damage": int(ship_item_dict["Damage"]),
        "ExplosiveForce": int(ship_item_dict["ExplosiveForce"]),
        "Fuel": int(ship_item_dict["Fuel"]),
        "Mass": int(ship_item_dict["Mass"])*100, # convert tons to kg
        "MaximumAcceleration": int(ship_item_dict["MaximumAcceleration"]),
        "MaximumScale": int(ship_item_dict["MaximumScale"]),
        "MaximumSpeed": int(ship_item_dict["MaximumSpeed"])*10, # convert to km/s
        "MaximumYawPitchRoll": list(map(int, ship_item_dict["MaximumYawPitchRoll"].split(","))),
        "PowerPlant": int(ship_item_dict["PowerPlant"]),
        "Radius": int(ship_item_dict["Radius"]),
        "Shields": list(map(int, ship_item_dict["Shields"].split())),
        "ShipClass": int(ship_item_dict["ShipClass"]),
        "Weapons": []
    }

    num_weapons = int(dict(elem_item[0].attrib.items())["WeaponsActive"])
    for idx, elem_weapon_item in enumerate(list(elem_item[0])):
        if idx < num_weapons:
            weapon_attr = dict(elem_weapon_item.items())
            weapon_attr = {
                "Hardpoint": int(weapon_attr["Hardpoint"]),
                "Selected": bool(weapon_attr["Selected"]),
                "WeaponType": int(weapon_attr["WeaponType"]),
            }
            ship_item["Weapons"].append(weapon_attr)
    return ship_item


def _convert_ship_view_mappings(elem):
    attr = dict(elem[0].attrib.items())
    ship_view_mapping = {
        "Missile": attr["Missile"].split(),
        "Ship": attr["Ship"].split(),
        "StarPost": attr["StarPost"].split()
    }
    return ship_view_mapping


def _convert_pilot(elem_item):
    attr = dict(elem_item.attrib.items())
    pilot = {
        "CallSign": attr["CallSign"],
        "Kills": int(attr["Kills"]),
        "LastName": attr["LastName"],
        "Rank": int(attr["Rank"]),
        "Sorties": int(attr["Sorties"]),
        "Unknown1": int(attr["Unknown1"]),
        "Unknown2": int(attr["Unknown2"])
    }
    return pilot


def _convert_cockpit_instrument_layout(elem_item, image_scale_factor):
    layout_item = {
        "ControlStick": {},
        "Radar": {},
        "Gauges": [],
        "Lights": [],
        "Readouts": [],
        "VideoDisplays": {"Left": {}, "Right": {}}
    }
    for elem_item_attribute in list(elem_item):
        if elem_item_attribute.tag.endswith("ControlStick"):
            radar_attr = dict(elem_item_attribute[0].attrib.items())
            layout_item["ControlStick"]["Bounds"] = parse_bounds(radar_attr["Bounds"], image_scale_factor)
            layout_item["ControlStick"]["Center"] = parse_position(radar_attr["Center"], image_scale_factor)
        elif elem_item_attribute.tag.endswith("Gauges"):
            for gauge_item in list(elem_item_attribute):
                gauge_attr = dict(gauge_item.attrib.items())
                gauge_attr = {
                    "Bounds": parse_bounds(gauge_attr["Bounds"], image_scale_factor),
                    "OffImage": int(gauge_attr["OffImage"]),
                    "OnImage": int(gauge_attr["OnImage"]),
                    "StepDirection": int(gauge_attr["StepDirection"]),
                    "Steps": int(gauge_attr["Steps"]),
                }
                layout_item["Gauges"].append(gauge_attr)
        elif elem_item_attribute.tag.endswith("Lights"):
            for gauge_item in list(elem_item_attribute):
                gauge_attr = dict(gauge_item.attrib.items())
                gauge_attr = {
                    "Position": parse_position(gauge_attr["Position"], image_scale_factor),
                    "OffImage": int(gauge_attr["OffImage"]),
                    "OnImage": int(gauge_attr["OnImage"]),
                }
                layout_item["Lights"].append(gauge_attr)
        elif elem_item_attribute.tag.endswith("Radar"):
            radar_attr = dict(elem_item_attribute[0].attrib.items())
            layout_item["Radar"]["Bounds"] = parse_bounds(radar_attr["Bounds"], image_scale_factor)
            layout_item["Radar"]["Center"] = parse_position(radar_attr["Center"], image_scale_factor)
        elif elem_item_attribute.tag.endswith("Readouts"):
            for gauge_item in list(elem_item_attribute):
                readout_attr = dict(gauge_item.attrib.items())
                readout_attr = parse_position(readout_attr["Position"], image_scale_factor)
                layout_item["Readouts"].append(readout_attr)
        elif elem_item_attribute.tag.endswith("VideoDisplays"):
            display_left = dict(elem_item_attribute[0].attrib.items())
            display_right = dict(elem_item_attribute[1].attrib.items())
            layout_item["VideoDisplays"]["Left"] = parse_bounds(display_left["Bounds"], image_scale_factor)
            layout_item["VideoDisplays"]["Right"] = parse_bounds(display_right["Bounds"], image_scale_factor)
    return layout_item
