class_name PlayerMedals
extends Node

@export var bronze_stars: int = 0
@export var silver_stars: int = 0
@export var gold_stars: int = 0
@export var gold_sun: int = 0
@export var pewter: int = 0
@export var ribbon_acad: bool = false # Academy Graduate
@export var ribbon_flts: bool = false # Flight School Graduate
@export var ribbon_vega: bool = false # Vega Campaign participant
@export var ribbon_horn: bool = false # Flew at least one mission in Hornet
@export var ribbon_rpir: bool = false # Flew at least one mission in Rapier
@export var ribbon_scim: bool = false # Flew at least one mission in Scimitar
@export var ribbon_rapt: bool = false # Flew at least one mission in Raptor
@export var ribbon_ace: bool = false # Achieved at least 5 kills
@export var ribbon_acea: bool = false # "Ace of Ace", Achieved at least 25 kills
@export var ribbon_5m: bool = false # 'Completed at least one mission (not MY error)
@export var ribbon_10m: bool = false # Completed at least 10 missions
@export var ribbon_15m: bool = false # Completed at least 15 missions


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
