@tool
class_name CutsceneCharacter
extends Node

@onready var body = $Body
@onready var eyes = $Body/Eyes
@onready var mouth = $Body/Mouth

## Location of the sprites
## 000=Full Body;
## 001-010=Mounth;
## 011-020=Eyes
@export_dir var assets_folder: String:
	set(value):
		assets_folder=value
		update_configuration_warnings()
		_update_textures()		

@export var eyes_index: int = 0:
	set(value):
		if(eyes != null):
			if(value<0):
				eyes_index = -1
			elif(value>=eyes.frame_count()):
				eyes_index = eyes.frame_count() - 1 
			else:
				eyes_index = value
			eyes.frame = eyes_index
			
@export var mounth_index: int = 0:
	set(value):
		if(mouth != null):
			if(value<0):
				mounth_index = -1
			elif(value>=mouth.frame_count()):
				mounth_index = mouth.frame_count() - 1 
			else:
				mounth_index = value
			mouth.frame = mounth_index
		
@export var text_color: Color = Color8(255,255,255,255)

func _ready():
	_update_textures()
		
func _update_textures():
	if (body != null):
		body.texture = load(assets_folder + "/000.png")
		if (eyes != null):
			var eyes_anim: AnimatedSprite2D = eyes
			eyes_anim.sprite_frames = SpriteFrames.new()
			eyes_anim.sprite_frames.clear_all()
			for frame_idx in range(1,11):
				var frame_texture = load(assets_folder + "/"+ str(frame_idx).lpad(3,"0").right(3) +".png")
				eyes_anim.sprite_frames.add_frame("default", frame_texture)
		if (eyes != null):
			var mouth_anim: AnimatedSprite2D = eyes
			mouth_anim.sprite_frames = SpriteFrames.new()
			mouth_anim.sprite_frames.clear_all()
			for frame_idx in range(11,21):
				var frame_texture = load(assets_folder + "/"+ str(frame_idx).lpad(3,"0").right(3) +".png")
				mouth_anim.sprite_frames.add_frame("default", frame_texture)

func _get_configuration_warnings():
	var warnings = []

	if assets_folder == "":
		warnings.append("Please set assets_folder` to a non-empty value.")

	for i in range(21): # 1 main picture, 10 mouth & 10 eyes images
		var file_name = str(i).lpad(4,"0") + ".png"
		if not FileAccess.file_exists(assets_folder + "/" + file_name):
			warnings.append("Expected image file `"+ file_name +"` in `assets_folder`, but file is missing.")

	# Returning an empty array means "no warning".
	return warnings
