extends Control

var screen_size : Vector2

var tween : Tween

@onready var camera := %Camera
@onready var ui := %UI
@onready var button_zoom := %ButtonZoom
@onready var button_dezoom := %ButtonDezoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.hide()
	screen_size = get_viewport_rect().size
	button_zoom.pressed.connect(zoom.bind(button_zoom))
	button_dezoom.pressed.connect(dezoom)

func _process(delta: float) -> void:
	camera.scale = Vector2(1 / camera.zoom.x, 1 / camera.zoom.y)

func zoom(button: Button) -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(camera, "position", button.size / 2 + button.position, 0.5)
	tween.set_parallel().tween_property(camera, "zoom", Vector2(screen_size.y / button.size.y, screen_size.y / button.size.y), 0.5)
	await tween.finished
	ui.show()
	
func dezoom() -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(camera, "position", screen_size / 2, 0.5)
	tween.set_parallel().tween_property(camera, "zoom", Vector2(1, 1), 0.5)
	await tween.finished
	ui.hide()
