extends Control


func _addImageToAlbum() -> void:
	var json_file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.WRITE)
	##json_file.store_string(JSON.stringify(result, "\t"))
	json_file.close()
	pass
