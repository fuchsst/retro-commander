extends Node

var phoneme_to_viseme_with_breaks = {
	'a': 1, 'i': 1, 'e': 2, 'o': 4, 'u': 5,
	'f': 6, 'v': 6, 'l': 7, 'm': 8, 'b': 8,
	'p': 8, 'q': 9, 'g': 9, 'k': 9, 's': 10,
	'z': 10, 't': 10, 'h': 10, 'r': 7, 'd': 9,
	'n': 7, 'w': 4, 'c': 9, 'y': 3, '0': 0  # '0' represents a break
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
