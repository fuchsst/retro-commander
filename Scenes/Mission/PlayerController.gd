extends Node3D
class_name PlayerController

@onready var ship: Ship = $".."
@onready var player_camera: Camera3D = $"../PlayerCamera"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	var pitch = 0.0
	var yaw = 0.0

	# Check for pitch inputs
	if Input.is_action_pressed("Pitch Down"):
		ship.rotate_object_local(Vector3.RIGHT, deg_to_rad(ship.ship_properties.maximum_pitch))
		World._on_camera_rotation(player_camera.global_rotation)
	if Input.is_action_pressed("Pitch Up"):
		ship.rotate_object_local(Vector3.LEFT, deg_to_rad(ship.ship_properties.maximum_pitch))
		World._on_camera_rotation(player_camera.global_rotation)

	# Check for yaw inputs
	if Input.is_action_pressed("Yaw Left"):
		ship.rotate_object_local(Vector3.UP, deg_to_rad(ship.ship_properties.maximum_yaw))
		World._on_camera_rotation(player_camera.global_rotation)
	if Input.is_action_pressed("Yaw Right"):
		ship.rotate_object_local(Vector3.DOWN, deg_to_rad(ship.ship_properties.maximum_yaw))
		World._on_camera_rotation(player_camera.global_rotation)
	if Input.is_action_pressed("Accelerate"):
		ship.current_kps += ship.ship_properties.cruise_speed/10
		if ship.current_kps > ship.ship_properties.cruise_speed:
			ship.current_kps = ship.ship_properties.cruise_speed
	if Input.is_action_pressed("Decelerate"):
		ship.current_kps -= ship.ship_properties.cruise_speed/10
		if ship.current_kps < 0:
			ship.current_kps = 0
	if Input.is_action_pressed("Full stop"):
		ship.current_kps = 0
