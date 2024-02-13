extends Node2D

@export var max_line_length: int= 300
@export var align_text_centered: bool = true
@export var text_color: Color = Color.WHITE_SMOKE:
	set(value):
		text_color=value
		if $TextureRect != null:
			$TextureRect.modulate = text_color


@export var text: String="":
	set(value):
		text=value
		if $TextureRect != null:
			$TextureRect.texture = generate_text_texture(text, align_text_centered)
			

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = generate_text_texture(text, align_text_centered)
	$TextureRect.modulate = text_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Example function to generate texture from text
func generate_text_texture(text: String, align_text_centered: bool) -> ImageTexture:
	var lines = [] # To store the lines and their widths
	var current_line = Image.create(max_line_length, 20, false, Image.FORMAT_RGBA8)
	var current_line_width = 0
	var max_line_height = 0
	var line_height = $Letters.sprite_frames.get_frame_texture("default", 0).get_height() # all should be the same height, so measure only the first is enough
	var text_bytes = text.to_ascii_buffer()
				
	var word_start = 0 # Start index of the current word
	for i in range(text_bytes.size()):
		var char = text_bytes[i]

		# Handle spaces and word wrapping
		if char == 32 or i == text_bytes.size() - 1:
			var word_width = measure_word_width(text_bytes, word_start, i)
			if current_line_width + word_width > max_line_length:
				lines.append([current_line, current_line_width])
				current_line = Image.create(max_line_length, line_height, false, Image.FORMAT_RGBA8)
				current_line_width = 0

			word_start = i + 1

		var glyph_index = char - 32
		var glyph_texture: CompressedTexture2D = $Letters.sprite_frames.get_frame_texture("default", glyph_index)
		var glyph_image = glyph_texture.get_image()
		copy_glyph_to_line(glyph_image, current_line, current_line_width)
		current_line_width += glyph_image.get_width()
		max_line_height = max(max_line_height, glyph_image.get_height())

	if current_line_width > 0:
		lines.append([current_line, current_line_width])

	var final_image = compose_final_image(lines, max_line_height)

	var final_texture = ImageTexture.create_from_image(final_image)
	return final_texture
	
func measure_word_width(text: PackedByteArray, start: int, end: int) -> int:
	var width = 0
	for i in range(start, end):
		var glyph_index = text[i] - 32
		var glyph_texture: CompressedTexture2D = $Letters.sprite_frames.get_frame_texture("default", glyph_index)
		var glyph_image = glyph_texture.get_image()
		width += glyph_image.get_width()
	return width

# Function to copy a glyph to the current line
func copy_glyph_to_line(glyph_image: Image, line_image: Image, line_width: int) -> Image:
	if line_image.is_empty():
		line_image.create(max_line_length, glyph_image.get_height(), false, Image.FORMAT_RGBA8)
		line_image.fill(Color(0, 0, 0, 0)) # Transparent background

	for x in range(glyph_image.get_width()):
		for y in range(glyph_image.get_height()):
			var color = glyph_image.get_pixel(x, y)
			color.a = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b
			line_image.set_pixel(line_width + x, y, color)

	return line_image

# Function to compose the final image from lines
func compose_final_image(lines: Array, line_height: int) -> Image:
	var total_height = lines.size() * line_height
	var image = Image.create(max_line_length, total_height, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0)) # Transparent background

	var y_offset = 0
	for line in lines:
		var line_image = line[0]
		var line_width = line[1]
		var x_offset = 0
		if (align_text_centered):
			x_offset = (max_line_length - line_width) / 2
		image.blit_rect(line_image, Rect2(Vector2.ZERO, line_image.get_size()), Vector2(x_offset, y_offset))
		y_offset += line_height

	print(image.get_size())
	print(max_line_length, ",", total_height)
	if align_text_centered and y_offset < total_height:
		var centered_image = Image.create(max_line_length, total_height, false, Image.FORMAT_RGBA8)
		centered_image.fill(Color(0, 0, 0, 0)) # Transparent background
		
		centered_image.blit_rect(image, Rect2(Vector2.ZERO, image.get_size()), Vector2(0, y_offset))
		
		return centered_image

	return image


