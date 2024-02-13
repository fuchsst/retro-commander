extends Node3D

@onready var rotation_label: Label = $Panel/GridContainer/rotationLabel
@onready var image_index_label: Label = $Panel/GridContainer/imageIndexLabel
@onready var ship_sprite: Sprite3D = $ShipSprite


var images = []
var rotx = 0
var roty = 0
var angles = [90, 60, 30, 0, 330, 300, 270, 240, 210, 180, 150, 120]
var positions = [
	[15, 16, 17, 18, 19, 20, 21, -20, -19, -18, -17, -16], # 0
	[14, 13, 12, 11, 10,  9,  8,  -9, -10, -11, -12, -13], # 1
	[ 1,  2,  3,  4,  5,  6,  7,  -6,  -5,  -4,  -3,  -2], # 2
	[ 0,  0,  0,  0,  0,  0,  0,   0,   0,   0,   0,   0], # 3
	[ 7,  6,  5,  4,  3,  2,  1,  -2,  -3,  -4,  -5,  -6], # 4
	[ 8,  9, 10, 11, 12, 13, 14, -13, -12, -11, -10,  -9], # 5
	[21, 20, 19, 18, 17, 16, 15, -16, -17, -18, -19, -20], # 6
	[22, 23, 24, 25, 26, 27, 28, -27, -26, -25, -24, -23], # 7
	[35, 34, 33, 32, 31, 30, 29, -30, -31, -32, -33, -34], # 8
	[36, 36, 36, 36, 36, 36, 36,  36,  36,  36,  36,  36], # 9
	[29, 30, 31, 32, 33, 34, 35, -34, -33, -32, -31, -30], #10
	[28, 27, 26, 25, 24, 23, 22, -23, -24, -25, -26, -27], #11
]
func _ready():
	load_images("res://Gamedata/shiptype.v00/000/")
	update_image()

func load_images(folder_path):
	for i in range(37):
		var image_path = folder_path + "%03d.png" % i
		images.append(load(image_path))

func update_image():
	var image_index = positions[roty][rotx]
	var mirrored = false
	if image_index < 0:
		image_index = -image_index
		mirrored = true
	var texture = images[image_index - 1] # Adjust for zero-based indexing
	ship_sprite.texture = texture
	ship_sprite.flip_h = mirrored
	if roty >= 4 and roty <= 8:
		ship_sprite.flip_v = true
	else:
		ship_sprite.flip_v = false
	rotation_label.text = "Rotation: " + str(angles[rotx]) + ":" + str(angles[roty])
	image_index_label.text = "Image Index (flipped/mirrored): " + str(image_index) + " (" + str(ship_sprite.flip_v) + "/" + str(mirrored) + ")"

func turn_clockwise():
	rotx = (rotx + 1) % positions[roty].size()
	update_image()

func turn_counterclockwise():
	rotx = (rotx - 1 + positions[roty].size()) % positions[roty].size()
	update_image()

func pitch_up():
	roty = (roty - 1 + positions.size()) % positions.size()
	update_image()

func pitch_down():
	roty = (roty + 1) % positions.size()
	update_image()

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				get_tree().quit()
			elif event.keycode == KEY_LEFT:
				turn_counterclockwise()
			elif event.keycode == KEY_RIGHT:
				turn_clockwise()
			elif event.keycode == KEY_UP:
				pitch_up()
			elif event.keycode == KEY_DOWN:
				pitch_down()
