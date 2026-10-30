extends Control

var tween: Tween

var played := false

@onready var playButton := %StartButton
@onready var albumButton := %AlbumButton
@onready var button_intro := %ButtonIntro

@onready var album_scene := %Album
@onready var scene1 := %Scene1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(play)
	albumButton.pressed.connect(launch_album)
	button_intro.pressed.connect(hide_intro)
	#albumButton.disabled = true
	_checkIfAlbumIsAvailable()

func hide_intro() -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	button_intro.add_theme_color_override("font_color",Color.TRANSPARENT)
	button_intro.add_theme_color_override("font_hover_color", Color.TRANSPARENT)
	button_intro.add_theme_color_override("font_outline_color", Color.TRANSPARENT)
	var stylebox = button_intro.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	button_intro.add_theme_stylebox_override("normal", stylebox)
	button_intro.add_theme_stylebox_override("hover", stylebox)
	button_intro.add_theme_color_override("font_color",Color.TRANSPARENT)

	tween.tween_property(stylebox, "bg_color", Color.TRANSPARENT, 0.5)
	await tween.finished
	button_intro.hide()

func play() -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(playButton, "scale", Vector2(1.1, 0.9), 0.05).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_property(playButton, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	scene1.show()

func launch_album() -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(albumButton, "scale", Vector2(1.1, 0.9), 0.05).set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_property(albumButton, "scale", Vector2.ONE, 0.05).set_trans(Tween.TRANS_BOUNCE)
	await tween.finished
	album_scene.show()

func _change_scene(scene_root):
	get_tree().change_scene_to_file(scene_root)

func _checkIfAlbumIsAvailable():
	var file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	if (json_string != "" ):
		albumButton.disabled = false
		albumButton.texture_normal = load("res://assets/dissier_fermer.png")
