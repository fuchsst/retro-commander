extends Node

signal camera_rotation_changed

@export var color_pallete: ColorPalette
var game_state: GameState = GameState.new()
var current_mission_dialogs: MissionDialogs
var current_bar_seating: BarSeatingProperties
var current_mission_state: MissionState


func _ready() -> void:
	game_state.savegame_filepath = "res://savegame.wld" # copy from WC1 GAMEDAT folder
	game_state = game_state.load(0)
	current_mission_dialogs = load_current_mission_dialogs()
	current_bar_seating = load_current_bar_seating()
	
func _on_camera_rotation(rot: Vector3):
	emit_signal("camera_rotation_changed", rot)
	
	
func load_current_mission_dialogs():
	var resource_file_name = "res://Assets/VegaCampaign/Season{0}/MissionDialogs{1}.tres".format([game_state.series, game_state.mission])
	return load(resource_file_name)
	
func load_current_bar_seating():
	var resource_file_name = "res://Assets/VegaCampaign/Season{0}/BarSeating{1}.tres".format([game_state.series, game_state.mission])
	return load(resource_file_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
