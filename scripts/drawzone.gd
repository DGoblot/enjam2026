extends Control

@onready var _lines := %Lines
@onready var area := %DrawZone
@onready var pencil_button := %ButtonPencil
@onready var eraser_button := %ButtonEraser
@onready var big_button := %ButtonBig
@onready var small_button := %ButtonSmall
@onready var black_button := %ButtonBlack
@onready var red_button := %ButtonRed
@onready var blue_button := %ButtonBlue
@onready var green_button := %ButtonGreen
@onready var yellow_button := %ButtonYellow

@onready var color_buttons_node := %ColorButtons

var color_buttons: Array[Node] 

@export var margin_small := 4
@export var margin_large := 8

var color: Color = Color.BLACK
var width: int = 8

var _pressed := false
var _current_line: Line2D
var eraser := false

@onready var screen_button := %Screen


func _ready() -> void:
	color_buttons = color_buttons_node.get_children()
	
	pencil_button.toggled.connect(_on_pencil_button_pressed)
	eraser_button.toggled.connect(_on_eraser_button_pressed)
	big_button.toggled.connect(_on_big_button_pressed)
	small_button.toggled.connect(_on_small_button_pressed)
	
	black_button.toggled.connect(_on_color_button_pressed.bind(black_button))
	red_button.toggled.connect(_on_color_button_pressed.bind(red_button))
	blue_button.toggled.connect(_on_color_button_pressed.bind(blue_button))
	green_button.toggled.connect(_on_color_button_pressed.bind(green_button))
	yellow_button.toggled.connect(_on_color_button_pressed.bind(yellow_button))
	
	small_button.button_pressed = true
	pencil_button.button_pressed = true
	black_button.button_pressed = true
	
	screen_button.pressed.connect(take_screenshoot)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_pressed = event.pressed
			
			if not _pressed:
				_current_line = null
			
			if _pressed and _is_mouse_in_area(event.global_position):
				_new_line()
				_current_line.add_point(_get_clamped_point(event.global_position))
				_current_line.add_point(_get_clamped_point(event.global_position+Vector2(0.001,0.001)))
			
	
	elif event is InputEventMouseMotion and _pressed:
		if _is_mouse_in_area(event.global_position):
			if not _current_line:
				_new_line()
			_current_line.add_point(_get_clamped_point(event.global_position))
		else:
			if _current_line:
				_current_line.add_point(_get_clamped_point(event.global_position))
				_current_line = null
				

func _new_line() -> void:
	_current_line = Line2D.new()
	_current_line.material = load("res://shaders/pencil_shader.tres")
	_current_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	_current_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	_current_line.antialiased = true
	_current_line.joint_mode = Line2D.LINE_JOINT_ROUND
	_lines.add_child(_current_line)
	_current_line.default_color = color
	_current_line.width = width

func _is_mouse_in_area(pos: Vector2) -> bool:
	return area.get_global_rect().has_point(pos)

func _get_clamped_point(pos: Vector2) -> Vector2:
	var rect: Rect2 = area.get_global_rect()
	var clamped : Vector2
	if width == 8:
		clamped = Vector2(
			clamp(pos.x, rect.position.x + margin_small, rect.end.x - margin_small),
			clamp(pos.y, rect.position.y + margin_small, rect.end.y - margin_small)
		)
	else:
		clamped = Vector2(
			clamp(pos.x, rect.position.x + margin_large, rect.end.x - margin_large),
			clamp(pos.y, rect.position.y + margin_large, rect.end.y - margin_large)
		)
	
	return clamped - global_position

func _on_pencil_button_pressed(_tmp: bool) -> void:
	color = Color.BLACK
	eraser_button.button_pressed = false
	pencil_button.disabled = true
	eraser_button.disabled = false
	
func _on_eraser_button_pressed(_tmp: bool) -> void:
	color = Color.WHITE
	pencil_button.button_pressed = false
	eraser_button.disabled = true
	pencil_button.disabled = false
	
func _on_big_button_pressed(_tmp: bool) -> void:
	width = 16
	small_button.button_pressed = false
	big_button.disabled = true
	small_button.disabled = false
	
func _on_small_button_pressed(_tmp: bool) -> void:
	width = 8
	big_button.button_pressed = false
	small_button.disabled = true
	big_button.disabled = false
	
func _on_color_button_pressed(_tmp: bool, button: Button) -> void:
	for button_iterator in color_buttons:
		button_iterator.disabled = false
	button.disabled = true
	
	match button.name:
		"ButtonBlack":
			color = Color.BLACK
		"ButtonRed":
			color = Color.RED
		"ButtonBlue":
			color = Color.BLUE
		"ButtonGreen":
			color = Color.GREEN
		"ButtonYellow":
			color = Color.YELLOW
	
	print(button.name)
	
func take_screenshoot() -> void:
	# Create the SubViewport 
	var sub_viewport = SubViewport.new()
	# Add the SubViewport to the tree
	add_child(sub_viewport)
	# Use the same World2D as the main Viewport
	sub_viewport.world_2d = get_viewport().world_2d
	# Set its size
	sub_viewport.size = Vector2(1920, 1080)
	# We only need it to update once for the screenshoot
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	# Move it to the place we want to take the screenshoot
	sub_viewport.canvas_transform.origin = Vector2(-0, 0)
	var date = Time.get_date_string_from_system().replace(".", "_")
	var time = Time.get_time_string_from_system().replace(":", "")
	var screenshot_path = "res://Images/screenshot_%s_%s.png" % [date, time]
	# Wait for the next frame to render
	await RenderingServer.frame_post_draw
	# Grab the image, save it and free the SubViewport
	var img = sub_viewport.get_texture().get_image()
	img.save_png(screenshot_path)
	_addImageToJSON(screenshot_path)
	sub_viewport.queue_free()
	

func _addImageToJSON(screenshot_path: String):
	var json_file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ_WRITE)
	var arrayListmagesPath = JSON.parse_string(json_file.get_as_text())
	arrayListmagesPath.append(screenshot_path)
	json_file.store_string(JSON.stringify(arrayListmagesPath, "\t"))
	json_file.close()
