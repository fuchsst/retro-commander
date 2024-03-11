class_name MissionShipProperties
extends Resource

enum ShipSide { FRIEND, FOE, NEUTRAL }

@export var ship_id: int
@export var flight_leader: int
@export var formation: int
@export var formation_slot: int
@export var mission_type: int
@export var orientation: Vector3
@export var pilot_level: int
@export var position: Vector3
@export var ship_type: int
@export var side: ShipSide
@export var speed_size: int
@export var sphere: int
@export var status: int
@export var target: int
@export var wing_leader: int


func _to_string() -> String:
	return "{ " + \
		'"ship_id": ' + str(ship_id) + ', ' + \
		'"flight_leader": ' + str(flight_leader) + ', ' + \
		'"formation": ' + str(formation) + ', ' + \
		'"formation_slot": ' + str(formation_slot) + ', ' + \
		'"mission_type": ' + str(mission_type) + ', ' + \
		'"orientation": ' + str(orientation) + ', ' + \
		'"pilot_level": ' + str(pilot_level) + ', ' + \
		'"position": ' + str(position) + ', ' + \
		'"ship_type": ' + str(ship_type) + ', ' + \
		'"side": ' + str(side) + ', ' + \
		'"speed_size": ' + str(speed_size) + ', ' + \
		'"sphere": ' + str(sphere) + ', ' + \
		'"status": ' + str(status) + ', ' + \
		'"target": ' + str(target) + ', ' + \
		'"wing_leader": ' + str(wing_leader) + \
		' }'

