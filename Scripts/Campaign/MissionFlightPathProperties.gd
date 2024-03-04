class_name MissionFlightPathProperties
extends Resource


@export var objective: int
@export var target: int
@export var text: String

func _to_string() -> String:
	return "{ " + \
		'"objective": ' + str(objective) + ', ' + \
		'"target": ' + str(target) + ', ' + \
		'"text": "' + str(text) + '"' + \
		' }'
