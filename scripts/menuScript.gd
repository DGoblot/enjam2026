extends Control

var tween: Tween

@onready var playButton = %StartButton
@onready var albumButton = %AlbumButton

@onready var album_scene := %Album
@onready var scene1 := %Scene1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(play)
	albumButton.pressed.connect(launch_album)
	#albumButton.disabled = true
	_checkIfAlbumIsAvailable()

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
