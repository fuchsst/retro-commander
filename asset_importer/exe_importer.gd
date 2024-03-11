extends Node

var ship_name_lookup = {
	"0" : "Hornet",
	"1" : "Rapier",
	"2" : "Scimitar",
	"3" : "Raptor",
}

func convert_wc1_exe_file():
	const src_file = "res://asset_importer/wc1_xml2json/output/wc.exe.json"
	const assets_dir = "res://Assets/"
	const image_dir = "res://Gamedata/"
	const cockpits_dst_dir = assets_dir+ "Cockpits/"
	const ships_dst_dir = assets_dir+ "Ships/"

	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(cockpits_dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		var instrument_layouts: Array = json_as_dict["CockpitInstrumentLayouts"]
		var damage_layouts: Array = json_as_dict["CockpitDamageLayouts"]
		var weapons_layouts: Array = json_as_dict["VideoDisplayWeapons"]
		var messaging: Array = json_as_dict["CockpitMessaging"]
		var ships: Array = json_as_dict["Ships"]

		for ship_index in range(len(instrument_layouts)):
			var ship_image_dir = image_dir + "pcship.v" + str(ship_index).pad_zeros(2) + "/"
			var _scene = create_cockpit_scene(
							ship_index,
							ship_image_dir,
							instrument_layouts[ship_index],
							damage_layouts.slice(ship_index*4, ship_index*4+4),
							weapons_layouts.slice(ship_index*5, ship_index*5+5),
							messaging[ship_index])
			var file_name = ("ShipV%02d" % ship_index) + ".tscn"
			ResourceSaver.save(_scene, cockpits_dst_dir + file_name)
			

		for ship_index in range(len(ships)):
			var _res = create_ship_properties_resource(ships[ship_index], json_as_dict["Hardpoints"])
			var file_name = ("ShipV%02d" % ship_index) + ".tres"
			ResourceSaver.save(_res, ships_dst_dir + file_name)

	else:
		print("Failed to open file: " + src_file)
		
func create_ship_properties_resource(ship_dict: Dictionary, hard_points:Array) -> ShipProperties:
	var ship_properties = ShipProperties.new()
	ship_properties.angular_inertia = ship_dict["AngularInertia"]
	ship_properties.armor_front = ship_dict["Armor"][0]/10
	ship_properties.armor_back = ship_dict["Armor"][1]/10
	ship_properties.armor_left = ship_dict["Armor"][2]/10
	ship_properties.armor_right = ship_dict["Armor"][3]/10
	ship_properties.cruise_speed = ship_dict["CruiseSpeed"]
	ship_properties.damage = ship_dict["Damage"]
	ship_properties.explosive_force = ship_dict["ExplosiveForce"]
	ship_properties.fuel = ship_dict["Fuel"]
	ship_properties.mass = ship_dict["Mass"]
	ship_properties.maximum_acceleration = ship_dict["MaximumAcceleration"]
	ship_properties.maximum_speed = ship_dict["MaximumSpeed"]
	ship_properties.maximum_yaw = ship_dict["MaximumYawPitchRoll"][0]/10
	ship_properties.maximum_pitch = ship_dict["MaximumYawPitchRoll"][1]/10
	ship_properties.maximum_roll = ship_dict["MaximumYawPitchRoll"][2]/10
	ship_properties.power_plant = ship_dict["PowerPlant"]
	ship_properties.radius = ship_dict["Radius"]/10
	ship_properties.shields_front = ship_dict["Shields"][0]/10
	ship_properties.shields_back = ship_dict["Shields"][1]/10
	ship_properties.ship_class = ship_dict["ShipClass"]

	var weapon_properties: Array[ShipWeaponProperties] = []
	for weapon_idx in range(len(ship_dict["Weapons"])):
		var weapon_dict = ship_dict["Weapons"][weapon_idx]
		var weapon = ShipWeaponProperties.new()
		var hardpoint_arr = hard_points[weapon_dict["Hardpoint"]]
		weapon.hardpoint = Vector3(hardpoint_arr["x"]/10, hardpoint_arr["y"]/10, hardpoint_arr["z"]/10)
		weapon.selected = weapon_dict["Selected"]
		weapon.weapon_type = weapon_dict["WeaponType"]
		weapon_properties.append(weapon)
	ship_properties.weapons.assign(weapon_properties)
	return ship_properties
	

func create_cockpit_scene(ship_index: int, ship_image_dir: String, instrument_layout: Dictionary, damage_layouts: Array, weapons_layouts:Array, messaging: Dictionary) -> PackedScene:

	var root = Node2D.new()
	root.name = "Cockpit"
	
	var front_view = Sprite2D.new()
	front_view.name = "FrontView"
	front_view.texture = load(ship_image_dir + "000/000.png")
	front_view.centered = false
	root.add_child(front_view)
	front_view.owner = root
	
	var right_view = Sprite2D.new()
	right_view.name = "RightView"
	right_view.texture = load(ship_image_dir + "001/000.png")
	right_view.centered = false
	right_view.visible = false
	root.add_child(right_view)
	right_view.owner = root
		
	var left_view = Sprite2D.new()
	left_view.name = "LeftView"
	left_view.texture = load(ship_image_dir + "002/000.png")
	left_view.centered = false
	left_view.visible = false
	root.add_child(left_view)
	left_view.owner = root
		
	var rear_view = Sprite2D.new()
	rear_view.name = "RearView"
	rear_view.texture = load(ship_image_dir + "003/000.png")
	rear_view.centered = false
	rear_view.visible = false
	root.add_child(rear_view)
	rear_view.owner = root
	
		
	var damages_node = Node2D.new()
	damages_node.name = "Damages"
	front_view.add_child(damages_node)
	damages_node.owner = root
	for damage_idx in range(4):
		var damage = damage_layouts[damage_idx]
		var damage_node = Sprite2D.new()
		damage_node.position.x = damage["x"]
		damage_node.position.y = damage["y"]
		damage_node.texture = load(ship_image_dir + "004/" + str(damage_idx).pad_zeros(3) + ".png")
		damage_node.name = "Damage" + str(damage_idx)
		damages_node.add_child(damage_node)
		damage_node.owner = root


	var radar_node = preload("res://Assets/Cockpits/Instruments/RadarWidget.tscn").instantiate()
	radar_node.position.x = instrument_layout["Radar"]["Center"]["x"]
	radar_node.position.y = instrument_layout["Radar"]["Center"]["y"]
	radar_node.radius = max(
		instrument_layout["Radar"]["Center"]["x"] - instrument_layout["Radar"]["Bounds"]["x1"],
		instrument_layout["Radar"]["Center"]["y"] - instrument_layout["Radar"]["Bounds"]["y1"],
		instrument_layout["Radar"]["Bounds"]["x2"] - instrument_layout["Radar"]["Center"]["x"],
		instrument_layout["Radar"]["Bounds"]["y2"] - instrument_layout["Radar"]["Center"]["y"]
	)
	
	radar_node.name = "Radar"
	front_view.add_child(radar_node)
	radar_node.owner = root

	var gauges_node = Node2D.new()
	gauges_node.name = "Gauges"
	front_view.add_child(gauges_node)
	gauges_node.owner = root
	for gauge_idx in range(len(instrument_layout["Gauges"])):
		var gauge = instrument_layout["Gauges"][gauge_idx]
		var gauge_node = Node2D.new()
		gauge_node.position.x = gauge["Bounds"]["x1"]
		gauge_node.position.y = gauge["Bounds"]["y1"]
		gauge_node.name = "Gauge" + str(gauge_idx)
		gauges_node.add_child(gauge_node)
		gauge_node.owner = root
		# TODO: replace Node2D with gauge scene (including direction and steps of the gauge)
		var gauge_on_image_node = Sprite2D.new()
		gauge_on_image_node.name = "OnSprite"
		gauge_on_image_node.texture = load(ship_image_dir + "007/" + str(gauge["OnImage"]).pad_zeros(3) + ".png")
		gauge_on_image_node.centered = false
		gauge_node.add_child(gauge_on_image_node)
		gauge_on_image_node.owner = root
		var gauge_off_image_node = Sprite2D.new()
		gauge_off_image_node.name = "OffSprite"
		gauge_off_image_node.texture = load(ship_image_dir + "007/" + str(gauge["OffImage"]).pad_zeros(3) + ".png")
		gauge_off_image_node.centered = false
		gauge_node.add_child(gauge_off_image_node)
		gauge_off_image_node.owner = root
		
	var lights_node = Node2D.new()
	lights_node.name = "Lights"
	front_view.add_child(lights_node)
	lights_node.owner = root
	for light_idx in range(len(instrument_layout["Lights"])):
		var light = instrument_layout["Lights"][light_idx]
		var light_node = Node2D.new()
		light_node.position.x = light["Position"]["x"]
		light_node.position.y = light["Position"]["y"]
		light_node.name = "Light" + str(light_idx)
		lights_node.add_child(light_node)
		light_node.owner = root
		# TODO: replace Node2D with gauge scene (including direction and steps of the gauge)
		var light_on_image_node = Sprite2D.new()
		light_on_image_node.name = "OnSprite"
		light_on_image_node.texture = load(ship_image_dir + "007/" + str(light["OnImage"]).pad_zeros(3) + ".png")
		light_on_image_node.centered = false
		light_node.add_child(light_on_image_node)
		light_on_image_node.owner = root
		var light_off_image_node = Sprite2D.new()
		light_off_image_node.name = "OffSprite"
		light_off_image_node.texture = load(ship_image_dir + "007/" + str(light["OffImage"]).pad_zeros(3) + ".png")
		light_off_image_node.centered = false
		light_node.add_child(light_off_image_node)
		light_off_image_node.owner = root
		
	var readouts_node = Node2D.new()
	readouts_node.name = "Readouts"
	front_view.add_child(readouts_node)
	readouts_node.owner = root
	for readout_idx in range(len(instrument_layout["Readouts"])):
		var readout = instrument_layout["Readouts"][readout_idx]
		var readout_node = Node2D.new()
		readout_node.position.x = readout["x"]
		readout_node.position.y = readout["y"]
		readout_node.name = "Readout" + str(readout_idx)
		readouts_node.add_child(readout_node)
		readout_node.owner = root
				
	var displays_node = Node2D.new()
	displays_node.name = "VideoDisplays"
	front_view.add_child(displays_node)
	displays_node.owner = root
	var left_display = instrument_layout["VideoDisplays"]["Left"]
	var left_display_node = Panel.new()
	left_display_node.position.x = left_display["x1"]
	left_display_node.position.y = left_display["y1"]
	left_display_node.size.x = left_display["x2"] - left_display["x1"]
	left_display_node.size.y = left_display["y2"] - left_display["y1"]
	left_display_node.name = "Left"
	displays_node.add_child(left_display_node)
	left_display_node.owner = root
	
	var weapons_node = Node2D.new()
	weapons_node.name = "Weapons"
	left_display_node.add_child(weapons_node)
	weapons_node.owner = root
	for weapons_idx in range(len(weapons_layouts)):
		var weapon = weapons_layouts[weapons_idx]
		var weapon_node = Sprite2D.new()
		weapon_node.position.x = weapon["x"]
		weapon_node.position.y = weapon["y"]
		weapon_node.texture = load(ship_image_dir + "009/" + str(weapons_idx).pad_zeros(3) + ".png")
		weapon_node.name = "Weapon" + str(weapons_idx)
		weapons_node.add_child(weapon_node)
		weapon_node.owner = root
	
	var right_display = instrument_layout["VideoDisplays"]["Right"]
	var right_display_node = Panel.new()
	right_display_node.position.x = right_display["x1"]
	right_display_node.position.y = right_display["y1"]
	right_display_node.size.x = right_display["x2"] - right_display["x1"]
	right_display_node.size.y = right_display["y2"] - right_display["y1"]
	right_display_node.name = "Right"
	displays_node.add_child(right_display_node)
	right_display_node.owner = root
	
		
	var massagings_node = Node2D.new()
	massagings_node.name = "CockpitMessaging"
	massagings_node.position.x = messaging["x"]
	massagings_node.position.y = messaging["y"]
	front_view.add_child(massagings_node)
	massagings_node.owner = root

	var constrol_stick_node = preload("res://Assets/Cockpits/Instruments/ControlStick.tscn").instantiate()
	constrol_stick_node.position.x = instrument_layout["ControlStick"]["Center"]["x"]
	constrol_stick_node.position.y = instrument_layout["ControlStick"]["Center"]["y"]
	constrol_stick_node.name = "ControlStick"
	front_view.add_child(constrol_stick_node)
	constrol_stick_node.owner = root
		
	

	var script = load("res://Scripts/Cockpit/Cockpit.gd")
	root.set_script(script)
	var scene = PackedScene.new()
	var result = scene.pack(root)
	return scene

		

func _on_pressed() -> void:
	convert_wc1_exe_file()
	
