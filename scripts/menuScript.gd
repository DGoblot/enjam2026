extends Control

@onready var playButton = %StartButton
@onready var albumButton = %AlbumButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playButton.pressed.connect(_change_scene.bind("res://scenes/test_colo.tscn"))
	albumButton.pressed.connect(_change_scene.bind("res://scenes/album.tscn"))
	albumButton.disabled = true
	
func _change_scene(scene_root):
	get_tree().change_scene_to_file(scene_root)

func _checkIfAlbumIsAvailable():
	var file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	if (json_string != "" ):
		albumButton.disabled = false
