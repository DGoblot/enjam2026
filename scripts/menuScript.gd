extends Control

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
	scene1.show()

func launch_album() -> void:
	album_scene.show()

func _change_scene(scene_root):
	get_tree().change_scene_to_file(scene_root)

func _checkIfAlbumIsAvailable():
	var file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	if (json_string != "" ):
		albumButton.disabled = false
