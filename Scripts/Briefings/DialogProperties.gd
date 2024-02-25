extends Resource
class_name DialogProperties

# Holds the characteristics of a dialog entry

@export var commands: Array[String] = []
@export var facial_expressions: Array[String] = []
@export var lip_sync_text: String = ""
@export var text: String = ""
@export var background: int
@export var foreground: int
@export var delay: int
@export var text_color: int


func _to_string() -> String:
	return "{ " + \
		'"commands": ' + str(commands) + ', ' + \
		'"facial_expressions": ' + str(facial_expressions) + ', ' + \
		'"lip_sync_text": ' + lip_sync_text + '", ' + \
		'"text": '  + text +  '", ' + \
		'"background": ' + str(background) + ', ' + \
		'"foreground": ' + str(foreground) + ', ' + \
		'"delay": ' + str(delay) + ', ' + \
		'"text_color": ' + str(text_color) + \
		' }'
