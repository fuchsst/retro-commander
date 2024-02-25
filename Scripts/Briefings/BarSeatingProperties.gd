extends Resource
class_name BarSeatingProperties


@export var left_pilot_id: int
@export var right_pilot_id: int

func _to_string() -> String:
	return "{ " + \
		'"left_pilot_id": ' + str(left_pilot_id) + ', ' + \
		'"right_pilot_id": ' + str(right_pilot_id) + \
		' }'
