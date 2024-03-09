extends Node3D
class_name Starfield

@export var number_of_stars: int = 500
@onready var main_star: Sprite3D = $MainStar
@onready var stars: Node3D = $Stars
@onready var camera_3d: Camera3D = $Camera3D


func set_camera_rotation(rot: Vector3):
	camera_3d.rotation = Vector3(rot.x,rot.y,rot.z)
	


func _ready() -> void:
	seed(main_star.texture.resource_path.hash())
	var sprites_dir = "res://Gamedata/planets.vga/000/"
	var images: Array[String] = ["028.png", "029.png", "030.png", "031.png", "032.png", "033.png", "034.png", "035.png", "036.png", "037.png"]
	for i in range(len(images)):
		images[i] = sprites_dir + images[i]
	generate_stars(images)
	World.camera_rotation_changed.connect(set_camera_rotation)
	var stellar_bkg: StellarBackgroundProperties = load("res://Assets/VegaCampaign/Season" + str(World.game_state.series) + "/StellarBackground" + str(World.game_state.mission) + ".tres")
	rotation_degrees = stellar_bkg.rotation
	main_star.texture = load("res://Gamedata/planets.vga/" + str(stellar_bkg.image).pad_zeros(3) + "/000.png")
		


func generate_stars(images: Array[String]) -> void:
	stars.get_children().clear()
	for i in range(number_of_stars):
		if images.size() == 0:
			return
		var sprite_path = images[randi() % images.size()]
		var texture = load(sprite_path) # Load the texture
		if texture:
			var sprite = Sprite3D.new()
			sprite.texture = texture

			# Generate random spherical coordinates
			var theta = randf() * PI # Polar angle
			var phi = randf() * 2 * PI # Azimuthal angle
			var r = 10.0 # Radius of 10 meters

			# Convert to Cartesian coordinates
			var x = r * sin(theta) * cos(phi)
			var y = r * sin(theta) * sin(phi)
			var z = r * cos(theta)

			# Set position
			sprite.global_transform.origin = Vector3(x, y, z)
			sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y

			stars.add_child(sprite)
		else:
			print("Failed to load texture: " + sprite_path)

