extends Node


func convert_wc1_exe_file():
	const src_file = "res://asset_importer/wc1_xml2json/output/wc.exe.json"
	const assets_dir = "res://Assets/"
	const image_dir = "res://Gamedata/"
	const cockpits_dst_dir = assets_dir+ "Cockpits/"

	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(cockpits_dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		var instrument_layouts: Array = json_as_dict["CockpitInstrumentLayouts"]
		var damage_layouts: Array = json_as_dict["CockpitDamageLayouts"]
		var messaging: Array = json_as_dict["CockpitMessaging"]
		for ship_index in range(len(instrument_layouts)):
			var ship_image_dir = image_dir + "pcship.v" + str(ship_index).pad_zeros(2) + "/"
			var _scene = create_cockpit_scene(ship_index, ship_image_dir, instrument_layouts[ship_index], damage_layouts.slice(ship_index*4, ship_index*4+4), messaging[ship_index])
			var file_name = ("ShipV%02d" % ship_index) + ".tscn"
			ResourceSaver.save(_scene, cockpits_dst_dir + file_name)

	else:
		print("Failed to open file: " + src_file)

func create_cockpit_scene(ship_index: int, ship_image_dir: String, instrument_layout: Dictionary, damage_layouts: Array, messaging: Dictionary) -> PackedScene:

	var root = Sprite2D.new()
	root.name = "Cockpit"
	print(ship_image_dir)
	root.texture = load(ship_image_dir + "000/000.png")
	root.centered = false

	# TODO: replace Node2D with controlstick scene
	var constrol_stick_node = Node2D.new()
	constrol_stick_node.position.x = instrument_layout["ControlStick"]["Bounds"]["x1"]
	constrol_stick_node.position.y = instrument_layout["ControlStick"]["Bounds"]["y1"]
	constrol_stick_node.name = "ControlStick"
	root.add_child(constrol_stick_node)
	constrol_stick_node.owner = root

	# TODO: replace Node2D with radar scene
	var radar_node = Node2D.new()
	radar_node.position.x = instrument_layout["Radar"]["Center"]["x"]
	radar_node.position.y = instrument_layout["Radar"]["Center"]["y"]
	radar_node.name = "Radar"
	root.add_child(radar_node)
	radar_node.owner = root

	var gauges_node = Node2D.new()
	gauges_node.name = "Gauges"
	root.add_child(gauges_node)
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
	root.add_child(lights_node)
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
	root.add_child(readouts_node)
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
	root.add_child(displays_node)
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
	
	var right_display = instrument_layout["VideoDisplays"]["Right"]
	var right_display_node = Panel.new()
	right_display_node.position.x = right_display["x1"]
	right_display_node.position.y = right_display["y1"]
	right_display_node.size.x = right_display["x2"] - right_display["x1"]
	right_display_node.size.y = right_display["y2"] - right_display["y1"]
	right_display_node.name = "Right"
	displays_node.add_child(right_display_node)
	right_display_node.owner = root

		
	

	var script = load("res://Scripts/Cockpit/Cockpit.gd")
	root.set_script(script)
	var scene = PackedScene.new()
	var result = scene.pack(root)
	return scene

		

func _on_pressed() -> void:
	convert_wc1_exe_file()
	
