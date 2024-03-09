extends Node


func convert_vega_campaign_module_file():
	const src_file = "res://asset_importer/wc1_xml2json/output/module.000.json"
	const assets_dir = "res://Assets/"
	const dst_dir = assets_dir+ "VegaCampaign/"
	
	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		print(len(json_as_dict["MissionSpheres"]))
		print(len(json_as_dict["MissionFlightPaths"]))
		print(len(json_as_dict["MissionShips"]))

		var camp_properties = CampaignProperties.new()
		camp_properties.campaign_id = 0
		camp_properties.campaign_name = "Vega Campaign"
		camp_properties.system_names.assign(json_as_dict["SystemNames"])
		ResourceSaver.save(camp_properties, dst_dir + "CampaignInfo.tres")
		for season_idx in range(len(json_as_dict["SystemNames"])):
			var season_dir = dst_dir + "Season" + str(season_idx) + "/"
			dir.make_dir_recursive(season_dir)
			for mission_idx in range(4):
				var mission_info_dict = json_as_dict["MissionInfos"][season_idx*4+mission_idx]
				var mission_spheres_dict = json_as_dict["MissionSpheres"].slice(season_idx*4*16+mission_idx*16, season_idx*4*16+mission_idx*16 + 16)
				var mission_flight_paths_dict = json_as_dict["MissionFlightPaths"].slice(season_idx*4*16+mission_idx*16, season_idx*4*16+mission_idx*16 + 16)
				var mission_ships_dict = json_as_dict["MissionShips"].slice(season_idx*4*32+mission_idx*32, season_idx*4*16+mission_idx*32 + 32)
				var wing_name = json_as_dict["WingNames"][season_idx*4+mission_idx]

				if mission_info_dict["YourShip"] != -1 or wing_name:
					var mission_info = MissionInfoProperties.new()
					mission_info.carrier = mission_info_dict["Carrier"]
					mission_info.convoy.assign(mission_info_dict["Convoy"])
					mission_info.initial_sphere = mission_info_dict["InitialSphere"]
					mission_info.spheres = _convert_spheres(mission_spheres_dict)
					mission_info.flight_paths = _convert_flight_paths(mission_flight_paths_dict)
					mission_info.ships = _convert_mission_ships(mission_ships_dict) # TODO check what this stores and how (why 32 entries?)
					mission_info.your_ship = mission_info_dict["YourShip"]
					mission_info.wing_name = wing_name
					ResourceSaver.save(mission_info, season_dir + "MissionInfos" + str(mission_idx) + ".tres")


#		var bar_seatings = json_as_dict["BarSeating"]
#		for i in range(len(bar_seatings)):
#			var seating_conf = BarSeatingProperties.new()
#			seating_conf.left_pilot_id = bar_seatings[i]["LeftSeat"] + 21 # adapt to match index used for character (e.g. dialog foregrounds)
#			seating_conf.right_pilot_id = bar_seatings[i]["RightSeat"] + 21
#			if seating_conf.left_pilot_id != seating_conf.right_pilot_id: # both the same == both 0 == no mission
#				var season = floor(i / 4) # Season 0 == flight simulator
#				var mission = i - ((season-1)*4)
#				var season_dir = dst_dir + "Season" + str(season) + "/"
#				dir.make_dir_recursive(season_dir)
#				ResourceSaver.save(seating_conf, season_dir + "BarSeating" + str(mission) + ".tres")


	else:
		print("Failed to open file: " + src_file)

func _convert_spheres(sphere_dicts: Array) -> Array[MissionSphereProperties]:
	var result: Array[MissionSphereProperties] = []
	for sphere_dict in sphere_dicts:
		var sphere_properties = MissionSphereProperties.new()
		sphere_properties.center = Vector3(sphere_dict["Center"]["x"], sphere_dict["Center"]["y"], sphere_dict["Center"]["z"])
		sphere_properties.name = sphere_dict["Name"]
		sphere_properties.radius = sphere_dict["Radius"]
		sphere_properties.ship_types.assign(sphere_dict["ShipTypes"])
		sphere_properties.ships.assign(sphere_dict["Ships"])
		sphere_properties.wave = sphere_dict["Wave"]
		sphere_properties.triggers.assign(_convert_sphere_triggers(sphere_dict["Triggers"]))
		result.append(sphere_properties)
	return result

func _convert_sphere_triggers(sphere_trigger_dicts: Array) -> Array[MissionSphereTriggerProperties]:
	var result: Array[MissionSphereTriggerProperties] = []
	for sphere_trigger_dict in sphere_trigger_dicts:
		var phere_trigger_properties = MissionSphereTriggerProperties.new()
		phere_trigger_properties.action = sphere_trigger_dict["Action"]
		phere_trigger_properties.sphere = sphere_trigger_dict["Sphere"]
		result.append(phere_trigger_properties)
	return result

func _convert_flight_paths(flight_path_dicts: Array) -> Array[MissionFlightPathProperties]:
	var result: Array[MissionFlightPathProperties] = []
	for flight_path_dict in flight_path_dicts:
		if flight_path_dict["Objective"] != -1:
			var flight_path_properties = MissionFlightPathProperties.new()
			flight_path_properties.objective = flight_path_dict["Objective"]
			flight_path_properties.target = flight_path_dict["Target"]
			flight_path_properties.text = flight_path_dict["Text"]
			result.append(flight_path_properties)
	return result


func _convert_mission_ships(mission_ship_dicts: Array) -> Array[MissionShipProperties]:
	var result: Array[MissionShipProperties] = []
	for mission_ship_dict in mission_ship_dicts:
		print(mission_ship_dict)
#		if flight_path_dict["Objective"] != -1:
#			var mission_ship_properties = MissionShipProperties.new()
#			mission_ship_properties.objective = mission_ship_dict["Objective"]
#			mission_ship_properties.target = mission_ship_dict["Target"]
#			mission_ship_properties.text = mission_ship_dict["Text"]
#			result.append(mission_ship_properties)
	return result

func _on_pressed() -> void:
	convert_vega_campaign_module_file()
	
