extends Node2D
class_name MissionScene

@onready var cockpit_overlay: Cockpit = $CockpitOverlay
@onready var cockpit_camera: Camera3D = $SubViewportContainer/SubViewport/Ship/PlayerCamera
@onready var ship: Ship = $SubViewportContainer/SubViewport/Ship

@onready var starfield: Node3D = $StarfieldViewportContainer/StarfieldViewport/Starfield
@onready var space: CanvasLayer = $SubViewportContainer/SubViewport/Space



enum PlayerView { COCKPIT_FRONT, COCKPIT_RIGHT, COCKPIT_BACK, COCKPIT_LEFT, CHASE_VIEW, BATTLE_CAM }

var view: PlayerView = PlayerView.COCKPIT_FRONT:
	set(value):
		view=value
		cockpit_overlay.visible=view in [PlayerView.COCKPIT_FRONT, PlayerView.COCKPIT_RIGHT, PlayerView.COCKPIT_BACK, PlayerView.COCKPIT_LEFT]
		ship.visible=not cockpit_overlay.visible
		
		if cockpit_overlay.visible:
			cockpit_camera.position = Vector3(0,0,0)
			if view==PlayerView.COCKPIT_FRONT:
				cockpit_overlay.view =Cockpit.CockpitView.FRONT
				cockpit_camera.rotation=Vector3(0,deg_to_rad(-180), 0)
			elif view==PlayerView.COCKPIT_RIGHT:
				cockpit_overlay.view=Cockpit.CockpitView.RIGHT
				cockpit_camera.rotation=Vector3(0, deg_to_rad(90), 0)
			elif view==PlayerView.COCKPIT_BACK:
				cockpit_overlay.view=Cockpit.CockpitView.REAR
				cockpit_camera.rotation=Vector3(0, 0, 0)
			elif view==PlayerView.COCKPIT_LEFT:
				cockpit_overlay.view=Cockpit.CockpitView.LEFT
				cockpit_camera.rotation=Vector3(0, deg_to_rad(-90), 0)
		else:
			cockpit_camera.position = Vector3(0, 6, -25)
			cockpit_camera.rotation = Vector3(0, deg_to_rad(-180), 0)
		World._on_camera_rotation(cockpit_camera.global_rotation)
			


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Look forward"):
		view = PlayerView.COCKPIT_FRONT
	elif Input.is_action_just_pressed("Look right"):
		view = PlayerView.COCKPIT_RIGHT
	elif Input.is_action_just_pressed("Look behind"):
		view = PlayerView.COCKPIT_BACK
	elif Input.is_action_just_pressed("Look left"):
		view = PlayerView.COCKPIT_LEFT
	elif Input.is_action_just_pressed("Chase view"):
		view = PlayerView.CHASE_VIEW
	
	#starfield.set_camera_rotation(space.get_node("Ship/PlayerCemera").rotation)
