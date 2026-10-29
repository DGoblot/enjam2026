extends Control

var active := false

var screen_size : Vector2

var tween : Tween

@onready var button_zoom := %ButtonZoom
@onready var button_dezoom := %ButtonDezoom
@onready var camera := %Camera
@onready var ui := %UI
@onready var draw_zone := %DrawZone
@onready var lines := %Lines

func _ready() -> void:
	ui.hide()
	screen_size = get_viewport_rect().size
	button_zoom.pressed.connect(zoom.bind(button_zoom))
	button_dezoom.pressed.connect(dezoom)

func _process(delta: float) -> void:
	lines.scale = Vector2(1/scale.x, 1/scale.y)

func zoom(button: Button) -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(camera, "position", get_global_rect().size / 2 + get_global_rect().position, 0.5)
	tween.set_parallel().tween_property(camera, "zoom", Vector2(screen_size.y / get_global_rect().size.y, screen_size.y / get_global_rect().size.y), 0.5)
	await tween.finished
	ui.show()
	draw_zone.active = true
	
func dezoom() -> void:
	print("ok")
	draw_zone.active = false
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	print("what ?")
	
	tween.tween_property(camera, "position", screen_size / 2, 0.5)
	tween.set_parallel().tween_property(camera, "zoom", Vector2(1, 1), 0.5)
	await tween.finished
	ui.hide()
