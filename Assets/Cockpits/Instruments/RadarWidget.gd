@tool
class_name RadarWidget
extends Node2D

@export var player_position: Ship

@export var wingmen: Array[Ship] = []
@export var enemies: Array[Ship] = []
@export var missles: Array[Ship] = []

@export var radius: float = 100.0


func _draw():
	var color_red = Color(0.8, 0, 0)
	var color_blue = Color(0, 0.1, 0.8)
	var color_yellow = Color(0.8, 0.8, 0.1)
	
	_draw_radar_background(Vector2(0,0))
	for object in wingmen:
		_draw_radar_objects(object, color_blue)
		
	for object in enemies:
		_draw_radar_objects(object, color_red)
		
	for object in missles:
		_draw_radar_objects(object, color_yellow)

		
func _draw_radar_objects(object: Node3D, color:Color) -> void:
	
	var relative_position = object.global_transform.origin - player_position.global_transform.origin
	var rotated_position = player_position.global_transform * relative_position

	var blip_position = map_3d_to_2d(rotated_position)
	print(blip_position)
	draw_circle(blip_position, 4, color)
		
func _draw_radar_background(center: Vector2):
	var color_green = Color(0, 0.8, 0.1)
	var color_black = Color(0, 0, 0)
	var line_width = 2.0
	var angle_45 = PI / 4  # 45 degrees in radians
	var angle_135 = 3 * PI / 4  # 135 degrees in radians
	var middle_radius = radius * 0.7
	var inner_radius = radius * 0.3

	# Draw filled circles with black color
	draw_circle(center, radius*1.1, color_black)
	draw_circle(center, middle_radius, color_black)
	draw_circle(center, inner_radius, color_black)

	# Draw circle outlines with green color
	draw_arc(center, radius, 0, 2 * PI, 64, color_green, line_width, true)
	draw_arc(center, middle_radius, 0, 2 * PI, 64, color_green, line_width, true)
	draw_arc(center, inner_radius, 0, 2 * PI, 64, color_green, line_width, true)

	# Draw diagonal section separator lines
	var top_right = Vector2(cos(angle_45), -sin(angle_45))
	var bottom_right = Vector2(cos(angle_45), sin(angle_45))
	var bottom_left = Vector2(cos(angle_135), sin(angle_45))
	var top_left = Vector2(cos(angle_135), -sin(angle_45))
	# top right
	draw_line(center + top_right * middle_radius,
			  center + top_right * inner_radius, 
			  color_green, line_width, true)

	# bottom right
	draw_line(center + bottom_right * middle_radius,
			  center + bottom_right * inner_radius, 
			  color_green, line_width, true)

	# bottom left
	draw_line(center + bottom_left * middle_radius,
			  center + bottom_left * inner_radius, 
			  color_green, line_width, true)

	# upper left
	draw_line(center + top_left * middle_radius,
			  center + top_left * inner_radius, 
			  color_green, line_width, true)
			

func map_3d_to_2d(relative_position):
	var direction = Vector2(relative_position.x, relative_position.z).normalized()
	var distance = 1-atan2(abs(direction.x), direction.y) / PI
	
	# Calculate left/right value (horizontal)
	var horizontal_direction = Vector2(relative_position.x, relative_position.z).normalized()
	var distance_horizontal = atan2(horizontal_direction.x, abs(horizontal_direction.y))
	var normalized_horizontal_value = distance_horizontal / PI * 2

	# Calculate above/below value (vertical)
	var vertical_direction = Vector2(relative_position.x, relative_position.y).normalized()
	var distance_vertical = atan2(abs(vertical_direction.x), vertical_direction.y)
	var normalized_vertical_value = distance_vertical / PI * 2 -1 
	
	var angle = atan2(normalized_horizontal_value, normalized_vertical_value)

	# Scale the distance to fit the radar size
	var radar_distance = distance * radius

	# Calculate the final position on the radar
	var radar_x = sin(angle) * radar_distance
	var radar_y = cos(angle) * radar_distance
	

	return Vector2(radar_x, radar_y)
