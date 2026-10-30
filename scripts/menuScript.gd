extends Control

var tween: Tween

const JSON_PATH = "user://listImagesAlbum.json"
const DEFAULT_JSON_PATH = "res://scripts/listImagesAlbum.json"

@onready var sound := %AudioStreamPlayer2D

var played := false

@onready var playButton := %StartButton
@onready var albumButton := %AlbumButton
@onready var button_intro := %ButtonIntro

@onready var album_scene := %Album
@onready var scene1 := %Scene1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sound.play()
	playButton.pressed.connect(play)
	albumButton.pressed.connect(launch_album)
	init_json()
	_checkIfAlbumIsAvailable()
	button_intro.pressed.connect(hide_intro)
	

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
	sound.stop()

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
	var json_file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ_WRITE)
	if not json_file:
		json_file = FileAccess.open("user://listImagesAlbum.json", FileAccess.READ_WRITE)
	var json_string = json_file.get_as_text()
	json_file.close()
	if (!JSON.parse_string(json_string).is_empty()):
		albumButton.disabled = false
		album_scene._allImages = album_scene._load_json_file()
		album_scene._putImageOnPage(0)
		albumButton.texture_normal = load("res://assets/dissier_fermer.png")
	
		
	
func next_scene(current: Node, next : int) -> void:
	current.hide()
	print(next)
	if next == 4:
		_checkIfAlbumIsAvailable()
	else:
		%Scenes.get_child(next).show()
		
func init_json():
	if not FileAccess.file_exists(JSON_PATH):
		print("wow")
		var default_file = FileAccess.open(DEFAULT_JSON_PATH, FileAccess.READ)

		if default_file == null:
			push_error(FileAccess.get_open_error())
			return
		
		var content = default_file.get_as_text()

		var save_file = FileAccess.open(JSON_PATH, FileAccess.WRITE)

		if save_file == null:
			push_error(FileAccess.get_open_error())
			return

		save_file.store_string(content)
		
