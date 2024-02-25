extends Node2D

@onready var table_rows: VFlowContainer = $Background/TableRows


const ranks = [
			"2ND LT.",
			"1ST LT.",
			"CAPTAIN",
			"MAJOR",
			"LT. COL."
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var all_pilots = [World.game_state.player]
	all_pilots.append_array(World.game_state.pilots)
	
	all_pilots.sort_custom(_sort_by_kills_desc)
	for row_idx in range(table_rows.get_child_count()):
		var pilot = all_pilots[row_idx]
		var row = table_rows.get_child(row_idx)
		row.get_child(0).text = ranks[pilot.rank] + " " + pilot.pilot_name
		row.get_child(1).text = str(pilot.missions)
		row.get_child(2).text = str(pilot.kills)
		print(pilot)

func _sort_by_kills_desc(a: Pilot, b: Pilot):
	return a.kills > b.kills

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_background_pressed():
	get_tree().change_scene_to_file("res://Scenes/OnBoard/Bar.tscn")
