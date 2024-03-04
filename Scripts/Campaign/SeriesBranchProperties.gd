extends Resource
class_name SeriesBranchProperties


@export var cutscene: int
@export var failure_series: int
@export var failure_ship: int
@export var missions_active: int
@export var success_score: int
@export var success_series: int
@export var success_ship: int
@export var wingman: int


func _to_string() -> String:
	return "{ " + \
		'"cutscene": ' + str(cutscene) + ', ' + \
		'"failure_series": ' + str(failure_series) + ', ' + \
		'"failure_ship": ' + str(failure_ship) + ', ' + \
		'"missions_active": ' + str(missions_active) + ', ' + \
		'"success_score": ' + str(success_score) + ', ' + \
		'"success_series": ' + str(success_series) + ', ' + \
		'"success_ship": ' + str(success_ship) + ', ' + \
		'"wingman": ' + str(wingman) + \
		' }'
