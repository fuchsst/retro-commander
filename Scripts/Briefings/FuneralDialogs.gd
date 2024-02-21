extends Resource
class_name FuneralDialogs

# Holds the dialogs played when player or wingman died

@export var player_funeral_end: Array[DialogProperties]
@export var player_funeral_start_early_game: Array[DialogProperties]
@export var player_funeral_start_middle_game: Array[DialogProperties]
@export var player_funeral_start_winning_game: Array[DialogProperties]
@export var player_funeral_start_losing_game: Array[DialogProperties]
@export var wingman_funeral_goodbye: Array[DialogProperties]
@export var wingman_funeral_start: Array[DialogProperties]

func _to_string() -> String:
	return "{ " + \
	"'player_funeral_end': " + str(player_funeral_end) + ", " + \
	"'player_funeral_start_early_game': " + str(player_funeral_start_early_game) + ", " +  \
	"'player_funeral_start_middle_game': " + str(player_funeral_start_middle_game) + ", " +  \
	"'player_funeral_start_winning_game': " + str(player_funeral_start_winning_game) + ", " +  \
	"'player_funeral_start_losing_game': " + str(player_funeral_start_losing_game) + ", " +  \
	"'wingman_funeral_goodbye': " + str(wingman_funeral_goodbye) + ", " +  \
	"'wingman_funeral_start': " + str(wingman_funeral_start) + \
	" }"
