extends Resource
class_name StellarBackgroundProperties

@export var image: int
@export var rotation: Vector3


func _to_string() -> String:
	return "{ " + \
		'"image": ' + str(image) + ', ' + \
		'"rotation": ' + str(rotation) + \
		' }'
