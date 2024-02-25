class_name Bar
extends CanvasLayer

@onready var left_character: BarCharacter = $ForegroundCanvas/TableTop/LeftCharacter
@onready var right_character: BarCharacter = $ForegroundCanvas/TableTop/RightCharacter
@onready var table_bottom: Node2D = $ForegroundCanvas/TableBottom


# Called when the node enters the scene tree for the first time.
func _ready():
	var anim : Animation= $BackgroundCanvas/Space/SpaceAnimation.get_animation("default")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	$BackgroundCanvas/Space/SpaceAnimation.play("default")
	
	left_character.active_character = World.current_bar_seating.left_pilot_id
	right_character.active_character = World.current_bar_seating.right_pilot_id

	$ForegroundCanvas/TableBottom/OnePersonRight.visible = not left_character.active_character_node and right_character.active_character_node
	$ForegroundCanvas/TableBottom/OnePersonLeft.visible = left_character.active_character_node and not right_character.active_character_node
	$ForegroundCanvas/TableBottom/TwoPerson.visible = left_character.active_character_node and right_character.active_character_node

