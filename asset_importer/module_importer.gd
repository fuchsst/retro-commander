extends Node


func _load_formations(wc_exe_json_path: String) -> Array[Vector3]:
	if FileAccess.file_exists(wc_exe_json_path):
		var json_as_text = FileAccess.get_file_as_string(wc_exe_json_path)
		var json_as_dict = JSON.parse_string(json_as_text)
		var result: Array[Vector3] = []
		for position in json_as_dict["FlightFormations"]:
			result.append(Vector3(position["x"], position["y"], position["z"]))
		return result
	else:
		print("Failed to open file: " + wc_exe_json_path)
		return []
	

func convert_vega_campaign_module_file():
	const wc_exe_src_file = "res://asset_importer/wc1_xml2json/output/wc.exe.json"
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
		
		var flight_formations = _load_formations(wc_exe_src_file)

		var camp_properties = CampaignProperties.new()
		camp_properties.campaign_id = 0
		camp_properties.campaign_name = "Vega Campaign"
		camp_properties.system_names.assign(json_as_dict["SystemNames"])
		ResourceSaver.save(camp_properties, dst_dir + "CampaignInfo.tres")
		for season_idx in range(len(json_as_dict["SystemNames"])):
			var season_dir = dst_dir + "Season" + str(season_idx) + "/"
			dir.make_dir_recursive(season_dir)
			for mission_idx in range(4):
				print("Converting Season", season_idx, " : Mission", mission_idx)
				var mission_info_dict = json_as_dict["MissionInfos"][season_idx*4+mission_idx]
				var mission_spheres_dict = json_as_dict["MissionSpheres"].slice(season_idx*4*16+mission_idx*16, season_idx*4*16+mission_idx*16 + 16)
				var mission_flight_paths_dict = json_as_dict["MissionFlightPaths"].slice(season_idx*4*16+mission_idx*16, season_idx*4*16+mission_idx*16 + 16)
				var mission_ships_dict = json_as_dict["MissionShips"].slice(season_idx*4*32+mission_idx*32, season_idx*4*32+mission_idx*32 + 32)
				var wing_name = json_as_dict["WingNames"][season_idx*4+mission_idx]

				if mission_info_dict["YourShip"] != -1 or wing_name:
					var mission_ships = _convert_mission_ships(mission_ships_dict, flight_formations) # TODO check what this stores and how (why 32 entries?)
					
					var mission_info = MissionInfoProperties.new()
					mission_info.carrier = mission_info_dict["Carrier"]
					
					for convoi_id in mission_info_dict["Convoy"]:
						if convoi_id != -1:
							mission_info.convoy.append(convoi_id)
					mission_info.initial_sphere = mission_info_dict["InitialSphere"]
					mission_info.spheres = _convert_spheres(mission_spheres_dict, mission_ships)
					mission_info.flight_paths = _convert_flight_paths(mission_flight_paths_dict)
					mission_info.your_ship = mission_ships[mission_info_dict["YourShip"]]
					mission_info.wing_name = wing_name
					ResourceSaver.save(mission_info, season_dir + "MissionInfos" + str(mission_idx) + ".tres")

	else:
		print("Failed to open file: " + src_file)

func _convert_spheres(sphere_dicts: Array, mission_ships) -> Array[MissionSphereProperties]:
	var result: Array[MissionSphereProperties] = []
	for sphere_dict in sphere_dicts:
		if sphere_dict["Radius"] > 0:
			var sphere_properties = MissionSphereProperties.new()
			sphere_properties.center = Vector3(sphere_dict["Center"]["x"], sphere_dict["Center"]["y"], sphere_dict["Center"]["z"])
			sphere_properties.name = sphere_dict["Name"]
			sphere_properties.radius = sphere_dict["Radius"]
			sphere_properties.ship_types.assign(sphere_dict["ShipTypes"])
			if mission_ships:
				for ship_id in sphere_dict["Ships"]:
					if ship_id != -1:
						var ship = mission_ships[ship_id]
						sphere_properties.ships.append(ship)
			sphere_properties.wave = sphere_dict["Wave"]
			sphere_properties.triggers.assign(_convert_sphere_triggers(sphere_dict["Triggers"]))
			result.append(sphere_properties)
	return result

func _convert_sphere_triggers(sphere_trigger_dicts: Array) -> Array[MissionSphereTriggerProperties]:
	var result: Array[MissionSphereTriggerProperties] = []
	for sphere_trigger_dict in sphere_trigger_dicts:
		if sphere_trigger_dict["Action"] != -1:
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


func _convert_mission_ships(mission_ship_dicts: Array, flight_formations: Array[Vector3]) -> Array[MissionShipProperties]:
	
	var result: Array[MissionShipProperties] = []
	for mission_ship_idx in range(len(mission_ship_dicts)):
		var mission_ship_dict = mission_ship_dicts[mission_ship_idx]
		if mission_ship_dict["ShipType"] != -1:
			
			var mission_ship_properties = MissionShipProperties.new()
			mission_ship_properties.ship_id = mission_ship_idx
			mission_ship_properties.flight_leader = mission_ship_dict["FlightLeader"]
			mission_ship_properties.formation = mission_ship_dict["Formation"]
			mission_ship_properties.formation_slot = mission_ship_dict["FormationSlot"]
			mission_ship_properties.mission_type = mission_ship_dict["MissionType"]
			mission_ship_properties.orientation = Vector3(deg_to_rad(mission_ship_dict["Orientation"]["x"]), deg_to_rad(mission_ship_dict["Orientation"]["y"]), deg_to_rad(mission_ship_dict["Orientation"]["z"]))
			mission_ship_properties.pilot_level = mission_ship_dict["PilotLevel"]
			if mission_ship_dict["FlightLeader"] != -1:
				var formation_position = flight_formations[mission_ship_dict["Formation"]*8+mission_ship_dict["FormationSlot"]]
				var flight_leader_position = mission_ship_dicts[mission_ship_dict["FlightLeader"]]["Position"]
				mission_ship_properties.position = Vector3(formation_position["x"]+flight_leader_position["x"], formation_position["y"]+flight_leader_position["y"], formation_position["z"]+flight_leader_position["z"])
				#print(formation_position, " : ", flight_leader_position, " = ", mission_ship_properties.position)
			else:
				mission_ship_properties.position = Vector3(mission_ship_dict["Position"]["x"], mission_ship_dict["Position"]["y"], mission_ship_dict["Position"]["z"])
				#print(mission_ship_properties.position)
			mission_ship_properties.ship_type = mission_ship_dict["ShipType"]
			mission_ship_properties.side = _int_to_side(mission_ship_dict["Side"])
			mission_ship_properties.speed_size = mission_ship_dict["SpeedSize"]
			mission_ship_properties.sphere = mission_ship_dict["Sphere"]
			mission_ship_properties.status = mission_ship_dict["Status"]
			mission_ship_properties.target = mission_ship_dict["Target"]
			mission_ship_properties.wing_leader = mission_ship_dict["WingLeader"]
			result.append(mission_ship_properties)
	return result
	
func _int_to_side(side: int) -> MissionShipProperties.ShipSide:
	if side==0:
		return MissionShipProperties.ShipSide.FRIEND
	elif side==1:
		return MissionShipProperties.ShipSide.FOE
	else:
		return MissionShipProperties.ShipSide.NEUTRAL

func _on_pressed() -> void:
	convert_vega_campaign_module_file()
	
