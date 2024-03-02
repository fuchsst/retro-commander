class_name ColorPalette
extends Resource

@export var colors: Array[Color] = []

func _to_string() -> String:
	return "{ " + \
		'"colors": ' + str(colors) + \
		' }'
