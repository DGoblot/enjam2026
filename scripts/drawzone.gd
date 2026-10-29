extends Control

var active := false

@onready var _lines := %Lines
@onready var area := %DrawZone
@onready var back_button := %ButtonBack
@onready var forward_button := %ButtonForward
@onready var pencil_button := %ButtonPencil
@onready var stylo_button := %ButtonStylo
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
var line_material := pencil_material


var _pressed := false
var _current_line: Line2D
var eraser := false


func _ready() -> void:
	color_buttons = color_buttons_node.get_children()
	
	back_button.pressed.connect(_on_back_button_pressed)
	forward_button.pressed.connect(_on_forward_button_pressed)
	
	pencil_button.toggled.connect(_on_pencil_button_pressed)
	stylo_button.toggled.connect(_on_stylo_button_pressed)
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
	add_line_to_array(_current_line)
	print(lines_array)
	print(lines_array_index)
	
func add_line_to_array(line: Line2D) -> void:
	for i in range(lines_array.size() - 1):
		if lines_array[i].visible == false:
			lines_array.pop_at(i)
			if i == lines_array.size() - 1: break
	if lines_array.size() >= 10:
		lines_array.pop_front()
	lines_array.append(line)
	lines_array_index = lines_array.size() - 1

func _is_mouse_in_area(pos: Vector2) -> bool:
	return area.get_global_rect().has_point(pos)

func _get_clamped_point(pos: Vector2) -> Vector2:
	pos
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
	
func _on_back_button_pressed() -> void:
	if lines_array_index <= lines_array.size() - 1 and lines_array_index >= 0:
		lines_array[lines_array_index].hide()
		lines_array_index -= 1
		
	
func _on_forward_button_pressed() -> void:
	if lines_array_index <= lines_array.size() - 2 and lines_array_index >= -1:
		lines_array_index += 1
		lines_array[lines_array_index].show()
