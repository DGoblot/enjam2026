extends Control

var active := false

@onready var _lines := %Lines
@onready var area := %DrawZone
@onready var pencil_button := %ButtonPencil
@onready var stylo_button := %ButtonStylo
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
var lines_array: Array[Line2D]
var lines_array_index: int = -1

@export var margin_small := 4
@export var margin_large := 8

var color: Color = Color.BLACK
var width: int = 8
var pencil_material := preload("res://shaders/pencil_shader.tres")
var eraser_material := preload("res://shaders/eraser_shader.tres")
var line_material := pencil_material
var camera_zoom: Vector2


var _pressed := false
var _current_line: Line2D

func _ready() -> void:
	color_buttons = color_buttons_node.get_children()
	
	pencil_button.toggled.connect(_on_pencil_button_pressed)
	stylo_button.toggled.connect(_on_stylo_button_pressed)
	eraser_button.pressed.connect(_on_eraser_button_pressed)
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

func _input(event: InputEvent) -> void:
	if not active:
		return
	
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
		if _is_mouse_in_area(get_global_mouse_position()):
			if not _current_line:
				_new_line()
			_current_line.add_point(_get_clamped_point(get_global_mouse_position()))
		else:
			if _current_line:
				_current_line.add_point(_get_clamped_point(get_global_mouse_position()))
				_current_line = null
				

func _new_line() -> void:
	_current_line = Line2D.new()
	if line_material:
		_current_line.material = line_material
	else:
		_current_line.material = null
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
	line_material = pencil_material
	stylo_button.button_pressed = false
	pencil_button.disabled = true
	stylo_button.disabled = false
	
func _on_stylo_button_pressed(_tmp: bool) -> void:
	line_material = null
	pencil_button.button_pressed = false
	stylo_button.disabled = true
	pencil_button.disabled = false
	
func _on_eraser_button_pressed() -> void:
	print("vpod")
	for line in _lines.get_children():
		line.queue_free()
	
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
	
func _on_color_button_pressed(_tmp: bool, button: TextureButton) -> void:
	for button_iterator in color_buttons :
		button_iterator.disabled = false
		button_iterator.button_pressed = false
		print(button_iterator.name)
	button.disabled = true
	
	match button.name:
		"ButtonBlack":
			color = Color("#1C0E0A")
		"ButtonRed":
			color = Color("#D8431B")
		"ButtonBlue":
			color = Color("#538A8D")
		"ButtonGreen":
			color = Color("#2E8E24")
		"ButtonYellow":
			color = Color("#D9CB92")
