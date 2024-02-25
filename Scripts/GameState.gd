class_name GameState
extends Node

signal savegame_file_loaded(saves: Array[GameState])
signal savegame_file_saved(saves: Array[GameState])

@export_file var savegame_filepath: String:
	set(value):
		savegame_filepath = value
		_read_savegame_file(savegame_filepath)
		
@export var player: Pilot
@export var pilots: Array[Pilot] = []
@export var ace_states: Array[int] = [1,1,1,1] #0A=KIA, 01=not seen, 29=fled  
@export var series: int = 1 # One-Based. ie S1M1 is 1, S2M1 is 2, etc 
@export var mission:int = 0 # Zero-Based. ie S1M1 is 0, S1M2 is 1, etc 
@export var campaign:int # 0=Vega Campaign, 1=Secret Missions
@export var kill_points:int
@export var victory_points:int
@export var promotion_points:int
@export var promotion_point_limit:int
@export var prev_kills: int
@export var wingman_prev_kills:int
@export var ejection_count: int
@export var date: int = 110
@export var year: int = 2654



var saves: Array[GameState] = []

const SAVEGAME_BLOCK_SIZE = 828

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	if savegame_filepath:
		_read_savegame_file(savegame_filepath)
		
func _to_string():
	return "GameState(
		player="+ str(player) + ", 
		pilots=" + str(pilots) + ", 
		ace_states="+str(ace_states) + ", 
		campaign=" + str(campaign)+ ", 
		series=" + str(series)+ ", 
		mission=" +str(mission) + ", 
		kill_points="+str(kill_points) + ", 
		victory_points="+str(victory_points)+ ", 
		promotion_points=" +str(promotion_points)+ ", 
		date="+str(date) +", 
		year="+str(year) +"
	)"


func _read_savegame_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var data = file.get_buffer(file.get_length())
		file.close()
		var num_saves = data.size() / SAVEGAME_BLOCK_SIZE
		saves.resize(num_saves)
		for i in range(0, num_saves):
			var save_slot_data = data.slice(i*SAVEGAME_BLOCK_SIZE, (i+1)*SAVEGAME_BLOCK_SIZE)
			var name_end_index = save_slot_data.find(0)
			var name = save_slot_data.slice(0, name_end_index).get_string_from_ascii()
			print("Loading ", name)
			saves[i] = null if name.begins_with("game ") else SaveGame.deserialize_savegame(save_slot_data)
		print("Savegame file " + filepath + " loaded")
		emit_signal("savegame_file_loaded")
	else:
		print_debug("Could not open savegame file ", savegame_filepath)


func load(index: int) -> GameState:
	if index == null or index < 0:
		print("Specify a game to load")
		return
	if index >= saves.size():
		print("Index too large")
		return
	if saves[index] == null:
		print("Slot empty")
		return
	var new_game_state=saves[index]
	print("Savegame " + str(index) + " loaded")
	return new_game_state

func save(index: int, savegame_name: String):
	if index == null or index < 0:
		print("Specify a game to save")
		return
	if index >= saves.size():
		print("Index too large")
		return
	var serialized_data = saves[index].serialize_savegame(savegame_name, $".")
	var file = FileAccess.open(savegame_filepath, FileAccess.READ_WRITE)
	if file != null:
		file.seek(index * 828)
		file.store_buffer(serialized_data)
		file.close()
		print("Savegame " + str(index) + " saved as " + savegame_name)
		emit_signal("savegame_file_saved")
