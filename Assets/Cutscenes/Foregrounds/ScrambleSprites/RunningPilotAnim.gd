extends Node2D

@onready var head: AnimatedSprite2D = $Body/Head
@onready var body: AnimatedSprite2D = $Body

@export_range(0,3,1) var head_type: int=0		
@export_range(0,12,1) var animation_start_offset: int=0

# Called when the node enters the scene tree for the first time.
func play() -> void:
	body.frame = animation_start_offset
	head.frame = head_type
	body.play("default")

func stop() -> void:
	body.stop()

