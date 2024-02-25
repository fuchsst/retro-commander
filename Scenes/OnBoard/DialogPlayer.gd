class_name DialogPlayer
extends Node2D

@export var mission_dialogs: MissionDialogs
@onready var subtitles_label: Label = $SubtitlesLabel
@onready var cutscene_character: CutsceneCharacter = $CutsceneCharacter

var phoneme_to_viseme_with_durations = {
	'a': {'viseme': 1, 'duration':  200/600},
	'i': {'viseme': 1, 'duration':  200/600},
	'e': {'viseme': 2, 'duration':  200/600},
	'y': {'viseme': 3, 'duration':  200/600},
	'o': {'viseme': 4, 'duration':  200/600},
	'w': {'viseme': 4, 'duration':  200/600},
	'u': {'viseme': 5, 'duration':  200/600},
	'f': {'viseme': 6, 'duration':  150/600},
	'v': {'viseme': 6, 'duration':  150/600},
	'l': {'viseme': 7, 'duration':  150/600},
	'r': {'viseme': 7, 'duration':  150/600},
	'n': {'viseme': 7, 'duration':  150/600},
	'm': {'viseme': 8, 'duration':  150/600},
	'b': {'viseme': 8, 'duration':  100/600},
	'p': {'viseme': 8, 'duration':  100/600},
	'q': {'viseme': 9, 'duration':  150/600},
	'g': {'viseme': 9, 'duration':  100/600},
	'k': {'viseme': 9, 'duration':  100/600},
	'd': {'viseme': 9, 'duration':  100/600},
	'c': {'viseme': 9, 'duration':  150/600},
	's': {'viseme': 10, 'duration': 150/600},
	'z': {'viseme': 10, 'duration': 150/600},
	't': {'viseme': 10, 'duration': 100/600},
	'h': {'viseme': 10, 'duration': 150/600}
}


var current_dialog_index: int = 0
var current_phoneme_index: int = -1
var current_phoneme_duration: float = 0.0
var current_phoneme_duration_left: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mission_dialogs:
		if current_dialog_index < len(mission_dialogs.bar_shotglass):
			var current_dialog = mission_dialogs.bar_shotglass[current_dialog_index]
			subtitles_label.text = current_dialog.text
			if current_phoneme_duration_left <= 0:
				current_phoneme_index += 1
				if current_phoneme_index < len(current_dialog.lip_sync_text):
					var phoneme = current_dialog.lip_sync_text[current_phoneme_index]
					if phoneme >= '0' and phoneme <= '9':
						cutscene_character.mouth_index = 0
						current_phoneme_duration = int(phoneme)
						current_phoneme_duration_left = int(phoneme)
					elif phoneme == "$":
						cutscene_character.mouth_index = 0
						current_phoneme_duration = current_dialog.delay
						current_phoneme_duration_left = current_dialog.delay
					else:
						cutscene_character.mouth_index = phoneme_to_viseme_with_durations[phoneme]["viseme"]
						current_phoneme_duration = phoneme_to_viseme_with_durations[phoneme]["duration"]
						current_phoneme_duration_left = phoneme_to_viseme_with_durations[phoneme]["duration"]
				else:
					current_dialog_index += 1
					current_phoneme_index = -1
			else:
				current_phoneme_duration_left -= current_phoneme_duration * delta
		else:
			cutscene_character.mouth_index = 0
