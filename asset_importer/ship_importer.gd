extends Node


var ship_name_lookup = {
	"0" : "Hornet",
	"1" : "Rapier",
	"2" : "Scimitar",
	"3" : "Raptor",
}

func convert_ships():
	const src_file = "res://asset_importer/wc1_xml2json/output/wc.exe.json"
	const dst_dir = "res://Assets/Ships/"
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)
		var ships_list = json_as_dict["Ships"]

		for key in ship_name_lookup:
			var value = ship_name_lookup[key]
			var ship_entry = ships_list[int(key)]
			var ship_resource = convert_to_resource_format(ship_entry)
			var save_path = dst_dir + value + ".tres"
			ResourceSaver.save(save_path, ship_resource)
	else:
		print("Failed to open file: " + src_file)

func convert_to_resource_format(ship_entry):
	var ship_properties = ShipProperties.new()
	ship_properties.angular_inertia = ship_entry["AngularInertia"]
	ship_properties.armor_front = ship_entry["Armor"][0]
	ship_properties.armor_back = ship_entry["Armor"][1]
	ship_properties.armor_left = ship_entry["Armor"][2]
	ship_properties.armor_right = ship_entry["Armor"][3]
	ship_properties.cruise_speed = ship_entry["CruiseSpeed"]
	ship_properties.damage = ship_entry["Damage"]
	ship_properties.explosive_force = ship_entry["ExplosiveForce"]
	ship_properties.fuel = ship_entry["Fuel"]
	ship_properties.mass = ship_entry["Mass"]
	ship_properties.maximum_acceleration = ship_entry["MaximumAcceleration"]
	ship_properties.maximum_speed = ship_entry["MaximumSpeed"]
	ship_properties.maximum_yaw = ship_entry["MaximumYawPitchRoll"][0]
	ship_properties.maximum_pitch = ship_entry["MaximumYawPitchRoll"][1]
	ship_properties.maximum_roll = ship_entry["MaximumYawPitchRoll"][2]
	ship_properties.power_plant = ship_entry["PowerPlant"]
	ship_properties.radius = ship_entry["Radius"]
	ship_properties.shields_front = ship_entry["Shields"][0]
	ship_properties.shields_back = ship_entry["Shields"][1]
	ship_properties.ship_class = ship_entry["ShipClass"]
	ship_properties.weapons = ship_entry["Weapons"]

	return ship_properties


func _on_pressed() -> void:
	pass # Replace with function body.
