extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Room/Crowd/FrontRow/000_Iceman".play("default")
	$"Room/Crowd/BackRow/006_Hunter".play("default")
	$Room/Stage/Commander.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
