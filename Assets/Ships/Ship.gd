class_name Ship
extends Node3D

@export var ship_properties: ShipProperties
@export var current_kps: float
@export var set_kps: float
@export var afterburner: bool = false
@export var front_shield: float
@export var back_shield: float
@export var front_armor: float
@export var back_armor: float
@export var left_armor: float
@export var right_armor: float
@export var locked_by_target: Ship
@export var locked_target: Ship




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward:Vector3 = Vector3.FORWARD
	forward = global_transform.basis.z

	global_translate((forward * current_kps) * delta)
