extends Node

const character_mapping = [
	{ "foreground_index": 20, "name": "Halcyon" },
	{ "foreground_index": 21, "name": "Spirit" },
	{ "foreground_index": 22, "name": "Hunter" },
	{ "foreground_index": 23, "name": "Bossman" },
	{ "foreground_index": 24, "name": "Iceman" },
	{ "foreground_index": 25, "name": "Angel" },
	{ "foreground_index": 26, "name": "Paladin" },
	{ "foreground_index": 27, "name": "Maniac" },
	{ "foreground_index": 28, "name": "Knight" },
	{ "foreground_index": 29, "name": "Bluehair" },
	{ "foreground_index": 30, "name": "Shotglass" }
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
			var scene = create_cutscene_character_scene(block, image_dir)
			ResourceSaver.save(scene, dst_dir + file_name)

	else:
		print("Failed to open file: " + src_file)
		
func create_cutscene_character_scene(json_data: Dictionary, base_path: String) -> PackedScene:
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
			sprite.position = Vector2(552, 296) # Vector2(json_data["Images"][i]["origin"]["x"], json_data["Images"][i]["origin"]["y"])
		else:
			eyes_node.add_child(sprite)
			sprite.name = "Eyes" + ("%02d" % (i-10))
			sprite.owner = root
			sprite.position = Vector2(448, 176)	


	var script = load("res://Scripts/Cutscenes/CutsceneCharacter.gd")
	root.set_script(script)
	var scene = PackedScene.new()
	var result = scene.pack(root)
	return scene


func _on_pressed() -> void:
	convert_talking()
