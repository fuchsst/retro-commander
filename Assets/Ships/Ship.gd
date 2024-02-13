class_name Ship
extends Node3D

# mapping of relative view on the ship to the sprite to display and if the sprite should be flipped (flag) and rotated rotated (degree on y axis)
var rotation_sprite_mapping = {
	Vector3(  60,    0, 0) : 7,
	Vector3(  60,  -30, 0) : 6,
	Vector3(  60,  -60, 0) : 5,
	Vector3(  60,  -90, 0) : 4,
	Vector3(  60, -120, 0) : 3,
	Vector3(  60, -150, 0) : 2,
	Vector3(  60, -180, 0) : 1,
	Vector3(  30,    0, 0) : 8,
	Vector3(  30,  -30, 0) : 9,
	Vector3(  30,  -60, 0) : 10,
	Vector3(  30,  -90, 0) : 11,
	Vector3(  30, -120, 0) : 12,
	Vector3(  30, -150, 0) : 13,
	Vector3(  30, -180, 0) : 14,
	Vector3(   0,    0, 0) : 21,
	Vector3(   0,  -30, 0) : 20,
	Vector3(   0,  -60, 0) : 19,
	Vector3(   0,  -90, 0) : 18,
	Vector3(   0, -120, 0) : 17,
	Vector3(   0, -150, 0) : 16,
	Vector3(   0, -180, 0) : 15,
	Vector3( -30,    0, 0) : 22,
	Vector3( -30,  -30, 0) : 23,
	Vector3( -30,  -60, 0) : 24,
	Vector3( -30,  -90, 0) : 25,
	Vector3( -30, -120, 0) : 26,
	Vector3( -30, -150, 0) : 27,
	Vector3( -30, -180, 0) : 28,
	Vector3( -60,    0, 0) : 35,
	Vector3( -60,  -30, 0) : 34,
	Vector3( -60,  -60, 0) : 33,
	Vector3( -60,  -90, 0) : 32,
	Vector3( -60, -120, 0) : 31,
	Vector3( -60, -150, 0) : 30,
	Vector3( -60, -180, 0) : 29,
	
	Vector3( -90,    0, 0) : -1,
	Vector3( -90,  -30, 0) : -1,
	Vector3( -90,  -60, 0) : -1,
	Vector3( -90,  -90, 0) : 36,
	Vector3( -90, -120, 0) : 31,
	Vector3( -90, -150, 0) : 30,
	Vector3( -90, -180, 0) : 29,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
