class_name Pilot
extends Node

enum Rank {SECOND_LT, FIRST_LT, CAPTAIN, MAJOR, LT_COL}
const Rank_Label_Mapping = {
	Rank.SECOND_LT: "2ND LT",
	Rank.FIRST_LT: "1ST LT",
	Rank.CAPTAIN: "CAPTAIN",
	Rank.MAJOR: "MAJOR",
	Rank.LT_COL: "LT COL"
}

@export var cutscene_character: CutsceneCharacter # Closeup of the face used in cutscenes
@export var scene_character: CutsceneCharacter # Bodyshot of the character used in the bar

@export var callsign: String
@export var pilot_name: String
@export var rank: Rank=Rank.FIRST_LT
@export var pilot_status: int=-1
@export var kills: int=0
@export var missions: int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init(callsign: String,
			pilot_name: String,
			rank: Rank=Rank.SECOND_LT,
			pilot_status: int=-1,
			kills: int=0,
			missions: int=0):
	self.callsign=callsign
	self.pilot_name=pilot_name
	self.rank=rank
	self.pilot_status=pilot_status
	self.kills=kills
	self.missions=missions

func _to_string() -> String:
	return "Pilot(callsign=" +callsign + ", pilot_name=" + pilot_name+", rank="+str(rank) + ", pilot_status=" +str(pilot_status)+ ", kills="+str(kills) + ", missions=" + str(missions) + ")"
