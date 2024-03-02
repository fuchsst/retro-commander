class_name DialogPlayer
extends Node2D

@export var mission_dialogs: Array[DialogProperties]
@export var background: PackedScene
@export var foreground: PackedScene
@onready var subtitles_label: Label = $SubtitlesLabel

@onready var background_node: Node2D = $Background
@onready var foreground_node: Node2D = $Foreground
@onready var current_foreground_instance: Node2D = null


#  1: open (4: ɛ, ʊ) -> e
#  2: wide open (12: h) -> h
#  3: big o-form (13: ɹ) -> o
#  4: small o-form (16: ʃ, tʃ, dʒ, ʒ) -> l, d, t
#  5: wide teeth together (15: s, z) -> c, s, z
#  6: closed mouth (21: p, b, m) -> n, m, b, p
#  7: lips pointed (7: w, u) -> u, q, y
#  8: opened (5: ɝ) -> r, a
#  9: slightly opened (18: f, v) -> w, f, v
# 10: smiling (6: j, i, ɪ) -> i, j, g, k

const phoneme_to_viseme_with_durations = {
	'a': {'viseme': 8,  'duration': 0.15},
	'i': {'viseme': 10, 'duration': 0.15},
	'e': {'viseme': 1,  'duration': 0.15},
	'y': {'viseme': 7,  'duration': 0.15},
	'o': {'viseme': 13, 'duration': 0.15},
	'w': {'viseme': 19, 'duration': 0.15},
	'u': {'viseme': 17, 'duration': 0.15},
	'f': {'viseme': 19, 'duration': 0.10},
	'v': {'viseme': 19, 'duration': 0.10},
	'l': {'viseme': 14, 'duration': 0.10},
	'j': {'viseme': 10, 'duration': 0.10},
	'r': {'viseme': 8,  'duration': 0.10},
	'n': {'viseme': 6,  'duration': 0.10},
	'm': {'viseme': 6,  'duration': 0.10},
	'b': {'viseme': 6,  'duration': 0.05},
	'p': {'viseme': 6,  'duration': 0.05},
	'q': {'viseme': 7,  'duration': 0.10},
	'g': {'viseme': 10, 'duration': 0.05},
	'k': {'viseme': 10, 'duration': 0.05},
	'd': {'viseme': 14, 'duration': 0.05},
	'c': {'viseme': 15, 'duration': 0.10},
	's': {'viseme': 15, 'duration': 0.10},
	'z': {'viseme': 15, 'duration': 0.10},
	't': {'viseme': 14, 'duration': 0.05},
	'h': {'viseme': 12, 'duration': 0.10}
}


const subtitle_colors = [
  Color(0.678, 0.847, 0.902),  # 0: Light blue
  Color(0.702, 0.533, 0.870),  # 1: Lavendar (Spirit)
  Color(0.255, 0.412, 0.882),  # 2: Royal Blue (Hunter)
  Color(1.0, 0.0, 0.0),        # 3: Red (Bossman/Jazz)
  Color(0.0, 1.0, 1.0),        # 4: Cyan (Iceman)
  Color(1.0, 0.855, 0.725),    # 5: Peach (Angel)
  Color(0.0, 0.0, 1.0),        # 6: Blue (Paladin/Doomsday)
  Color(0.0, 1.0, 0.0),        # 7: Electric Green (Maniac)
  Color(0.647, 0.165, 0.165),  # 8: Brown (Knight)
  Color(1.0, 1.0, 0.0),        # 9: Yellow (Bluehair)
  Color(0.259, 0.431, 0.024),  # 10: Pea Green (Shotglass)
  Color(0.827, 0.827, 0.827),  # 11: medium light gray
  Color(0.502, 0.502, 0.502),  # 12: medium gray
  Color(0.961, 0.961, 0.961),  # 13: very light gray
  Color(0.184, 0.184, 0.184),  # 14: very dark gray
  Color(0.333, 0.333, 0.333),  # 15: medium dark gray
  Color(0.827, 0.827, 0.827),  # 16: medium light gray
]




var is_playing: bool = false
var has_ended: bool = false
var current_dialog_index: int = 0
var current_phoneme_index: int = -1
var current_phoneme_duration: float = 0.0
var current_phoneme_duration_left: float = 0.0

func _ready() -> void:
	_set_foreground_and_background(mission_dialogs[0])

func set_dialogs(dialogs: Array[DialogProperties]) -> DialogPlayer:
	self.mission_dialogs = dialogs
	is_playing = true
	return self

func _process(delta: float) -> void:
	if mission_dialogs and is_playing and current_dialog_index < mission_dialogs.size():
		var current_dialog = mission_dialogs[current_dialog_index]
		_handle_phoneme_timing(delta, current_dialog)
	else:
		_end_dialog_playback()

func _handle_phoneme_timing(delta: float, current_dialog: DialogProperties):
	if current_phoneme_duration_left <= 0:
		_advance_to_next_phoneme_or_dialog(current_dialog)
	else:
		current_phoneme_duration_left -= delta

func _advance_to_next_phoneme_or_dialog(current_dialog: DialogProperties):
	current_phoneme_index += 1
	if current_phoneme_index < current_dialog.lip_sync_text.length():
		_process_current_phoneme(current_dialog.lip_sync_text[current_phoneme_index])
	else:
		_advance_to_next_dialog()

func _process_current_phoneme(phoneme: String):
	var viseme_info = phoneme_to_viseme_with_durations.get(phoneme, {"viseme": 0, "duration": 1})
	current_foreground_instance.mouth_index = viseme_info.viseme
	current_phoneme_duration = viseme_info.duration
	current_phoneme_duration_left = viseme_info.duration

func _advance_to_next_dialog():
	current_dialog_index += 1
	current_phoneme_index = -1
	if current_dialog_index < mission_dialogs.size():
		_set_foreground_and_background(mission_dialogs[current_dialog_index])

func _end_dialog_playback():
	has_ended = true
	is_playing = false
	current_foreground_instance.mouth_index = 0



func _set_foreground_and_background(current_dialog: DialogProperties):
	if current_dialog:
		subtitles_label.text = _replace_placeholder(current_dialog.text)
		subtitles_label.label_settings.font_color = subtitle_colors[current_dialog.text_color]
		_load_scene_into_node(background_node, "res://Assets/Cutscenes/Backgrounds/", current_dialog.background)
		_load_scene_into_node(foreground_node, "res://Assets/Cutscenes/Foregrounds/", current_dialog.foreground, true)

func _load_scene_into_node(node: Node2D, path: String, id: int, is_character: bool=false):
	var scene = _get_scene(path, id)
	if scene:
		var instance = scene.instantiate()
		if is_character:
			if current_foreground_instance:
				node.remove_child(current_foreground_instance)
				current_foreground_instance.queue_free()
			instance.set_script(load("res://Scripts/Cutscenes/CutsceneCharacter.gd"))
			current_foreground_instance = instance
		else:
			node.get_children().remove_at(0)
		node.add_child(instance)


func _get_scene(path, id: int):
	var code = str(id).pad_zeros(3) + "_"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if file_name.begins_with(code):
				return load(path + file_name)
			file_name = dir.get_next()
	return null


func _replace_placeholder(text: String) -> String :
	return text.replace("$A", "MEDAL TO BE AWARDED") \
			.replace("$C", World.game_state.player.callsign) \
			.replace("$D", str(World.game_state.year) + ", " + str(World.game_state.date)) \
			.replace("$E", "PREVIOUS DATE (FOR MEDAL CEREMONY)") \
			.replace("$K", "KILLS LAST MISSION") \
			.replace("$L", "WINGMAN KILLS LAST MISSION") \
			.replace("$N", World.game_state.player.pilot_name) \
			.replace("$P", "NAME (NEVER USED)") \
			.replace("$R", "RANK") \
			.replace("$S", "SYSTEM") \
			.replace("$T", "TIME OF NEXT MISSION")


func _on_texture_button_pressed() -> void:
	if has_ended:
		print("Exit click")
		get_tree().change_scene_to_file("res://Scenes/OnBoard/Bar.tscn")
	else:
		print("Next shot click")
		current_dialog_index += 1
		if current_dialog_index < mission_dialogs.size():
			current_phoneme_index = -1
			current_phoneme_duration_left = 0.0
			_set_foreground_and_background(mission_dialogs[current_dialog_index])
		else:
			# If there are no more dialogs, end playback.
			_end_dialog_playback()

