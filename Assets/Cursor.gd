class_name Cursor
extends Node

@export var is_hovering_action_area = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$".".global_position = get_viewport().get_mouse_position() / $"..".get_scale()
	if(is_hovering_action_area):
		$ArrowSprite.set_frame(1)
		$ArrowSprite.set_centered(true)
	else:
		$ArrowSprite.set_frame(0)
		$ArrowSprite.set_centered(false)



func _on_interaction_area_entered(tooltip_text: String):
	is_hovering_action_area=true
	$"../TooltipText".text = tooltip_text


func _on_interaction_area_exited():
	is_hovering_action_area=false
	$"../TooltipText".text = ""
