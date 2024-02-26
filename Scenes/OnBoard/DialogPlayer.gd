class_name DialogPlayer
extends Node2D

@export var mission_dialogs: Array[DialogProperties]
@export var background: PackedScene
@export var foreground: PackedScene
@onready var subtitles_label: Label = $SubtitlesLabel
@onready var cutscene_character: CutsceneCharacter = $Foreground



const phoneme_to_viseme_with_durations = {
	'a': {'viseme': 1, 'duration':  0.20},
	'i': {'viseme': 1, 'duration':  0.20},
	'e': {'viseme': 2, 'duration':  0.20},
	'y': {'viseme': 3, 'duration':  0.20},
	'o': {'viseme': 4, 'duration':  0.20},
	'w': {'viseme': 4, 'duration':  0.20},
	'u': {'viseme': 5, 'duration':  0.20},
	'f': {'viseme': 6, 'duration':  0.15},
	'v': {'viseme': 6, 'duration':  0.15},
	'l': {'viseme': 7, 'duration':  0.15},
	'r': {'viseme': 7, 'duration':  0.15},
	'n': {'viseme': 7, 'duration':  0.15},
	'm': {'viseme': 8, 'duration':  0.15},
	'b': {'viseme': 8, 'duration':  0.10},
	'p': {'viseme': 8, 'duration':  0.10},
	'q': {'viseme': 9, 'duration':  0.15},
	'g': {'viseme': 9, 'duration':  0.10},
	'k': {'viseme': 9, 'duration':  0.10},
	'd': {'viseme': 9, 'duration':  0.10},
	'c': {'viseme': 9, 'duration':  0.15},
	's': {'viseme': 10, 'duration': 0.15},
	'z': {'viseme': 10, 'duration': 0.15},
	't': {'viseme': 10, 'duration': 0.10},
	'h': {'viseme': 10, 'duration': 0.15}
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




var is_playing: bool = true
var has_ended: bool = false
var current_dialog_index: int = 0
var current_phoneme_index: int = -1
var current_phoneme_duration: float = 0.0
var current_phoneme_duration_left: float = 0.0

func set_dialogs(dialogs: Array[DialogProperties]) -> DialogPlayer:
	self.mission_dialogs = dialogs
	return self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mission_dialogs and is_playing:
		if current_dialog_index < len(mission_dialogs):
			var current_dialog = mission_dialogs[current_dialog_index]
			subtitles_label.text = _replace_placeholder(current_dialog.text)
			subtitles_label.label_settings.font_color = subtitle_colors[current_dialog.text_color]
			background = _get_scene("res://Assets/Cutscenes/Backgrounds/", current_dialog.background)
			foreground = _get_scene("res://Assets/Cutscenes/Foregrounds/", current_dialog.foreground)
			if current_phoneme_duration_left <= 0:
				current_phoneme_index += 1
				if current_phoneme_index < len(current_dialog.lip_sync_text):
					var phoneme = current_dialog.lip_sync_text[current_phoneme_index]
					if phoneme >= '0' and phoneme <= '9':
						cutscene_character.mouth_index = 0
						current_phoneme_duration = int(phoneme)/10
						current_phoneme_duration_left = int(phoneme)/10
					elif phoneme == "$":
						cutscene_character.mouth_index = 0
					else:
						var visime = phoneme_to_viseme_with_durations[phoneme]
						cutscene_character.mouth_index = visime["viseme"] if visime else 0
						current_phoneme_duration = visime["duration"] if visime else 1
						current_phoneme_duration_left = visime["duration"] if visime else 1
				else:
					current_dialog_index += 1
					current_phoneme_index = -1
			else:
				current_phoneme_duration_left -= delta
		else:
			has_ended = true
			is_playing = false
			cutscene_character.mouth_index = 0



func _get_scene(path, id: int):
	var code = str(id).pad_zeros(3) + "_"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name and not file_name.begins_with(code):
			file_name = dir.get_next()
		if file_name.begins_with(code):
			return load(file_name)
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
