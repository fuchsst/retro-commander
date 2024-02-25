extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for savegame in World.game_state.saves:
		print(savegame.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_save_slot_pressed(slot: int) -> void:
	print("Save slot " + str(slot))


func _on_unused_pressed(slot: int) -> void:
	print("Save slot " + str(slot))


func _on_load_slot_pressed(slot: int) -> void:
	print("Load slot " + str(slot))
