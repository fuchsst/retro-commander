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
