extends Node

const SCALE_FACTOR = 4

const character_mapping = [
	{ "foreground_index": 20, "name": "Halcyon",   "mouth_pos" : Vector2(138*SCALE_FACTOR, 74*SCALE_FACTOR), "eyes_pos" : Vector2(113*SCALE_FACTOR, 45*SCALE_FACTOR) },
	{ "foreground_index": 21, "name": "Spirit",    "mouth_pos" : Vector2(139*SCALE_FACTOR, 77*SCALE_FACTOR), "eyes_pos" : Vector2(126*SCALE_FACTOR, 47*SCALE_FACTOR) },
	{ "foreground_index": 22, "name": "Hunter",    "mouth_pos" : Vector2(152*SCALE_FACTOR, 82*SCALE_FACTOR), "eyes_pos" : Vector2(140*SCALE_FACTOR, 47*SCALE_FACTOR) },
	{ "foreground_index": 23, "name": "Bossman",   "mouth_pos" : Vector2(116*SCALE_FACTOR, 80*SCALE_FACTOR), "eyes_pos" : Vector2(112*SCALE_FACTOR, 41*SCALE_FACTOR) },
	{ "foreground_index": 24, "name": "Iceman",    "mouth_pos" : Vector2(142*SCALE_FACTOR, 86*SCALE_FACTOR), "eyes_pos" : Vector2(124*SCALE_FACTOR, 43*SCALE_FACTOR) },
	{ "foreground_index": 25, "name": "Angel",     "mouth_pos" : Vector2(126*SCALE_FACTOR, 80*SCALE_FACTOR), "eyes_pos" : Vector2(120*SCALE_FACTOR, 55*SCALE_FACTOR) },
	{ "foreground_index": 26, "name": "Paladin",   "mouth_pos" : Vector2(131*SCALE_FACTOR, 76*SCALE_FACTOR), "eyes_pos" : Vector2(116*SCALE_FACTOR, 43*SCALE_FACTOR) },
	{ "foreground_index": 27, "name": "Maniac",    "mouth_pos" : Vector2(138*SCALE_FACTOR, 79*SCALE_FACTOR), "eyes_pos" : Vector2(116*SCALE_FACTOR, 48*SCALE_FACTOR) },
	{ "foreground_index": 28, "name": "Knight",    "mouth_pos" : Vector2(132*SCALE_FACTOR, 77*SCALE_FACTOR), "eyes_pos" : Vector2(125*SCALE_FACTOR, 44*SCALE_FACTOR) },
	{ "foreground_index": 29, "name": "Bluehair",  "mouth_pos" : Vector2(127*SCALE_FACTOR, 81*SCALE_FACTOR), "eyes_pos" : Vector2(127*SCALE_FACTOR, 44*SCALE_FACTOR) },
	{ "foreground_index": 30, "name": "Shotglass", "mouth_pos" : Vector2(124*SCALE_FACTOR, 76*SCALE_FACTOR), "eyes_pos" : Vector2(113*SCALE_FACTOR, 46*SCALE_FACTOR) }
]

func convert_talking():
	const src_file = "res://asset_importer/wc1_xml2json/output/talking.vga.json"
	const image_dir = "res://Gamedata/"
	const assets_dir = "res://Assets/"
	const dst_dir = assets_dir+ "Cutscenes/Foregrounds/"

	var dir = DirAccess.open(assets_dir)
	dir.make_dir_recursive(dst_dir)
	
	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)
		var image_blocks = json_as_dict["ImageBlocks"]

		for i in range(len(character_mapping)):
			var block = image_blocks[i]
			var file_name = ("%03d" % character_mapping[i]["foreground_index"]) + "_"+character_mapping[i]["name"]+".tscn"
			var mouth_pos = character_mapping[i]["mouth_pos"]
			var eyes_pos = character_mapping[i]["eyes_pos"]
			var scene = create_cutscene_character_scene(block, image_dir, mouth_pos, eyes_pos)
			ResourceSaver.save(scene, dst_dir + file_name)

	else:
		print("Failed to open file: " + src_file)
		
func create_cutscene_character_scene(json_data: Dictionary, base_path: String, mouth_pos: Vector2, eyes_pos: Vector2) -> PackedScene:
	var root = Node2D.new()
	root.name = "CutsceneCharacter"
	

	var face_sprite = Sprite2D.new()
	face_sprite.texture = load(base_path + json_data["Images"][0]["file"])
	face_sprite.centered = false
	# face_sprite.offset = Vector2(json_data["Images"][0]["origin"]["x"], json_data["Images"][0]["origin"]["y"])
	face_sprite.name = "Face"
	root.add_child(face_sprite)
	face_sprite.owner = root

	var mouth_node = Node2D.new()
	mouth_node.name = "Mouth"
	root.add_child(mouth_node)
	mouth_node.owner = root
	
	var eyes_node = Node2D.new()
	eyes_node.name = "Eyes"
	root.add_child(eyes_node)
	eyes_node.owner = root
	
	for i in range(1, 21):
		var sprite = Sprite2D.new()
		sprite.texture = load(base_path + json_data["Images"][i]["file"])
		sprite.centered = false
		# sprite.visible = false
		if i <= 10:
			mouth_node.add_child(sprite)
			sprite.name = "Mouth" + ("%02d" % i)
			sprite.owner = root
			sprite.position = mouth_pos
		else:
			eyes_node.add_child(sprite)
			sprite.name = "Eyes" + ("%02d" % (i-10))
			sprite.owner = root
			sprite.position = eyes_pos


	var script = load("res://Scripts/Cutscenes/CutsceneCharacter.gd")
	root.set_script(script)
	var scene = PackedScene.new()
	var result = scene.pack(root)
	return scene


func _on_pressed() -> void:
	convert_talking()
