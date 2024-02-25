class_name Cursor
extends Node

@export var is_hovering_action_area = false

@onready var tooltip_text_label: Label = $"../TooltipTextLabel"
@onready var arrow_sprite: AnimatedSprite2D = $ArrowSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$".".global_position = get_viewport().get_mouse_position() / $"..".get_scale()
	if(is_hovering_action_area):
		arrow_sprite.set_frame(1)
		arrow_sprite.set_centered(true)
	else:
		arrow_sprite.set_frame(0)
		arrow_sprite.set_centered(false)



func _on_interaction_area_entered(tooltip_text: String):
	is_hovering_action_area=true
	tooltip_text_label.text = tooltip_text


func _on_interaction_area_exited():
	is_hovering_action_area=false
	tooltip_text_label.text = ""
