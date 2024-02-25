extends Node


func convert_game_pal_file():
	const src_file = "res://asset_importer/wc1_xml2json/output/game.pal.json"
	const dst_dir = "res://Assets/"

	if FileAccess.file_exists(src_file):
		var json_as_text = FileAccess.get_file_as_string(src_file)
		var json_as_dict = JSON.parse_string(json_as_text)

		var palette_colors = json_as_dict["PaletteColors"]
		var palette_resource = ColorPalette.new()
		for color in palette_colors:
			palette_resource.colors.append(
				Color(
					color["r"] / 255.0, 
					color["g"] / 255.0, 
					color["b"]  / 255.0
				)
			)
		palette_resource.colors[255] = Color(0,0,0,0) # transparent
		ResourceSaver.save(palette_resource, dst_dir + "ColorPalette.tres")
				

	else:
		print("Failed to open file: " + src_file)
		

func _on_pressed() -> void:
	convert_game_pal_file()
