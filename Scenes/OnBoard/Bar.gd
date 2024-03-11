class_name Bar
extends CanvasLayer

@onready var left_character: BarCharacter = $ForegroundCanvas/TableTop/LeftCharacter
@onready var right_character: BarCharacter = $ForegroundCanvas/TableTop/RightCharacter
@onready var table_bottom: Node2D = $ForegroundCanvas/TableBottom
@onready var cursor: Cursor = $OverlayCanvas/Cursor


# Called when the node enters the scene tree for the first time.
func _ready():
	left_character.active_character = World.current_bar_seating.left_pilot_id
	right_character.active_character = World.current_bar_seating.right_pilot_id

	$ForegroundCanvas/TableBottom/OnePersonRight.visible = not left_character.active_character_node and right_character.active_character_node
	$ForegroundCanvas/TableBottom/OnePersonLeft.visible = left_character.active_character_node and not right_character.active_character_node
	$ForegroundCanvas/TableBottom/TwoPerson.visible = left_character.active_character_node and right_character.active_character_node



func _on_talk_to_shotglass_button_pressed() -> void:
	var cutscene_player = preload("res://Scenes/OnBoard/DialogPlayer.tscn").instantiate()
	cutscene_player.set_dialogs(World.current_mission_dialogs.bar_shotglass)
	get_tree().root.add_child(cutscene_player)
	get_tree().root.remove_child(self)


func _on_view_pilot_stats_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/OnBoard/Scoreboard.tscn")


func _on_talk_to_left_character_button_mouse_entered() -> void:
	cursor._on_interaction_area_entered("Talk to " + left_character.get_active_character_name())


func _on_talk_to_right_character_button_mouse_entered() -> void:
	cursor._on_interaction_area_entered("Talk to " + right_character.get_active_character_name())


func _on_talk_to_right_character_button_pressed() -> void:
	var cutscene_player = preload("res://Scenes/OnBoard/DialogPlayer.tscn").instantiate()
	cutscene_player.set_dialogs(World.current_mission_dialogs.bar_right_pilot)
	get_tree().root.add_child(cutscene_player)
	get_tree().root.remove_child(self)


func _on_talk_to_left_character_button_pressed() -> void:
	var cutscene_player = preload("res://Scenes/OnBoard/DialogPlayer.tscn").instantiate()
	cutscene_player.set_dialogs(World.current_mission_dialogs.bar_left_pilot)
	get_tree().root.add_child(cutscene_player)
	get_tree().root.remove_child(self)
