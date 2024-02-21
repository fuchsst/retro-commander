extends Resource
class_name MissionDialogs

# Holds the dialogs for each mission

@export var briefing: Array[DialogProperties]
@export var debriefing: Array[DialogProperties]
@export var bar_shotglass: Array[DialogProperties]
@export var bar_left_pilot: Array[DialogProperties]
@export var bar_right_pilot: Array[DialogProperties]

func _to_string() -> String:
	return "{ " + \
	"'briefing': " + str(briefing) + ", " + \
	"'debriefing': " + str(debriefing) + ", " +  \
	"'bar_shotglass': " + str(bar_shotglass) + ", " +  \
	"'bar_left_pilot': " + str(bar_left_pilot) + ", " +  \
	"'bar_right_pilot': " + str(bar_right_pilot) + \
	" }"
