@tool
class_name CutsceneCharacter
extends Node2D

@export var mission_dialogs: MissionDialogs

@export_range(0, 10) var mouth_index: int:
	set(new_index):
		mouth_index = new_index
		if mouth_sprites:		
			for i in range(len(mouth_sprites)):
				mouth_sprites[i].visible = i == mouth_index-1
			
@export_range(0, 10) var eye_index: int:
	set(new_index):
		eye_index = new_index
		if eye_sprites:
			for i in range(len(eye_sprites)):
				eye_sprites[i].visible = i == eye_index-1

@onready var mouth_sprites = $Mouth.get_children()
@onready var eye_sprites = $Eyes.get_children()

func _ready():
	mouth_index = 0
	eye_index = 0

