class_name Bar
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var anim : Animation= $BackgroundCanvas/Space/SpaceAnimation.get_animation("default")
	anim.loop_mode =(Animation.LOOP_LINEAR)
	$BackgroundCanvas/Space/SpaceAnimation.play("default")

