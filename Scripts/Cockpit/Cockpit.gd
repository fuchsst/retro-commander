extends Node2D
class_name Cockpit

enum CockpitView {FRONT, LEFT, REAR, RIGHT}

@onready var front: Node2D = $FrontView
@onready var right: Node2D = $RightView
@onready var left: Node2D = $LeftView
@onready var rear: Node2D = $RearView
@onready var radar: RadarWidget = $FrontView/Radar

@export var player_ship: Ship:
	set(value):
		radar.player_position = value
	get:
		if radar:
			return radar.player_position
		else:
			return null

@export var view: CockpitView = CockpitView.FRONT:
	set(value):
		view = value
		if (front):
			front.visible = view==CockpitView.FRONT
		if (right):
			right.visible = view==CockpitView.RIGHT
		if (rear):
			rear.visible = view==CockpitView.REAR
		if (left):
			left.visible = view==CockpitView.LEFT


