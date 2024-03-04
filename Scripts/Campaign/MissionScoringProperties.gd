class_name MissionScoringProperties
extends Resource


@export var flight_path_scoring: Array[int] = []
@export var medal: int
@export var medal_score: int

func _to_string() -> String:
	return "{ " + \
		'"flight_path_scoring": ' + str(flight_path_scoring) + ', ' + \
		'"medal": ' + str(medal) + ', ' + \
		'"medal_score": ' + str(medal_score) + \
		' }'
