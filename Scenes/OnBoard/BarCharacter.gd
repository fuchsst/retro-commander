class_name BarCharacter
extends Node2D

@export var active_character: int:
	set(pilot_id):
		active_character = pilot_id
		var active_character_code = str(pilot_id).pad_zeros(3)
		active_character_node = null
		for node: Sprite2D in get_children():
			node.visible = node.name.begins_with(active_character_code)
			if node.visible:
				active_character_node = node
			
var active_character_node: Sprite2D

func get_active_character_name() -> String:
	if active_character_node:
		return active_character_node.name.substr(4)
	else:
		return "???"
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
