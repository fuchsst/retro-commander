extends Resource
class_name ShipProperties

# Holds the characteristics of a ship type like shileds, maneuverability, etc.

@export_subgroup("Type and Size")
@export var ship_class: int
@export var mass: float
@export var radius: float
@export_subgroup("Armor and Shields")
@export var shields_front: float
@export var shields_back: float
@export var armor_front: float
@export var armor_left: float
@export var armor_right: float
@export var armor_back: float
@export_subgroup("Maneuverability")
@export var angular_inertia: float
@export var cruise_speed: float
@export var maximum_acceleration: float
@export var maximum_speed: float
@export var maximum_yaw: float
@export var maximum_pitch: float
@export var maximum_roll: float
@export_subgroup("Subsystem properties")
@export var damage: float
@export var explosive_force: float
@export var fuel: float
@export var power_plant: float
@export var weapons: Array[ShipWeaponProperties]
