class_name MissionSphereTriggerProperties
extends Resource


@export var action: int
@export var sphere: int

func _to_string() -> String:
	return "{ " + \
		'"action": ' + str(action) + ', ' + \
		'"sphere": "' + str(sphere) + '"' + \
		' }'
