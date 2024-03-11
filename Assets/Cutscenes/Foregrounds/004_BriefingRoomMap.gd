extends Node2D

@onready var starfield: Starfield = $Background/NavMapBackground/SubViewport/Starfield

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starfield.set_camera_rotation(Vector3(1,0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
