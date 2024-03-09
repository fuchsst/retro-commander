extends Node2D
class_name ControlStick

const stick_direction_change_delta = 2
var stick_direction: Vector2 = Vector2(0, 0)

@onready var hand_anim_sprite: AnimatedSprite2D = $HandAnimSprite



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("Left","Right", "Up", "Down")
	
	if input.x != 0:
		stick_direction.x += stick_direction_change_delta*delta*input.x
	else:
		stick_direction.x -= stick_direction_change_delta*delta*sign(stick_direction.x)
	stick_direction.x = clamp(stick_direction.x, -1, 1)
	if abs(stick_direction.x)<0.1 and input.x==0:
		stick_direction.x = 0
	if abs(stick_direction.y)<0.1 and input.y==0:
		stick_direction.y = 0
	
	if input.y != 0:
		stick_direction.y += stick_direction_change_delta*delta*input.y
	else:
		stick_direction.y -= stick_direction_change_delta*delta*sign(stick_direction.y)
	stick_direction.y = clamp(stick_direction.y, -1, 1)
	
	if stick_direction.y < 0:
		hand_anim_sprite.animation = "push"
		hand_anim_sprite.frame = floor(4 * abs(stick_direction.y))
	elif stick_direction.y > 0:
		hand_anim_sprite.animation = "pull"
		hand_anim_sprite.frame = floor(4 * abs(stick_direction.y))
	elif stick_direction.x < 0:
		hand_anim_sprite.animation = "left"
		hand_anim_sprite.frame = floor(4 * abs(stick_direction.x))
	elif stick_direction.x > 0:
		hand_anim_sprite.animation = "right"
		hand_anim_sprite.frame = floor(4 * abs(stick_direction.x))
