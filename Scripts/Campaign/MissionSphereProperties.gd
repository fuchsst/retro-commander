class_name MissionSphereProperties
extends Resource


@export var center: Vector3
@export var name: String
@export var radius: int
@export var ship_types: Array[int]
@export var ships: Array[int]
@export var wave: int
@export var triggers: Array[MissionSphereTriggerProperties]

func _to_string() -> String:
	return "{ " + \
		'"center": ' + str(center) + ', ' + \
		'"name": "' + str(name) + '", ' + \
		'"radius": ' + str(radius) + ', ' + \
		'"ship_types": ' + str(ship_types) + ', ' + \
		'"ships": ' + str(ships) + ', ' + \
		'"wave": ' + str(wave) + ', ' + \
		'"triggers": ' + str(triggers) + \
		' }'

