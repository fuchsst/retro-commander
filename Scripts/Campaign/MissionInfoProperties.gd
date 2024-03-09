class_name MissionInfoProperties
extends Resource


@export var carrier: int
@export var convoy: Array[int]
@export var initial_sphere: int
@export var spheres: Array[MissionSphereProperties]
@export var flight_paths: Array[MissionFlightPathProperties]
@export var ships: Array[MissionShipProperties]
@export var your_ship: int
@export var wing_name: String

func _to_string() -> String:
	return "{ " + \
		'"carrier": ' + str(carrier) + ', ' + \
		'"convoy": ' + str(convoy) + ', ' + \
		'"initial_sphere": ' + str(initial_sphere) + ', ' + \
		'"spheres": ' + str(spheres) + ', ' + \
		'"flight_paths": ' + str(flight_paths) + ', ' + \
		'"ships": ' + str(ships) + ', ' + \
		'"your_ship": ' + str(your_ship) + ', ' + \
		'"wing_name": "' + str(wing_name) + '"' + \
		' }'


