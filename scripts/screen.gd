extends Control

@onready var screen_button := %ButtonScreen

func _ready() -> void:
	screen_button.pressed.connect(take_screenshoot)

func take_screenshoot() -> void:
	# Create the SubViewport 
	var sub_viewport = SubViewport.new()
	# Add the SubViewport to the tree
	add_child(sub_viewport)
	# Use the same World2D as the main Viewport
	sub_viewport.world_2d = get_viewport().world_2d
	# Set its size
	sub_viewport.size = Vector2(1920, 1080)
	# We only need it to update once for the screenshoot
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	# Move it to the place we want to take the screenshoot
	sub_viewport.canvas_transform.origin = Vector2(-0, 0)
	var date = Time.get_date_string_from_system().replace(".", "_")
	var time = Time.get_time_string_from_system().replace(":", "")
	var screenshot_path = "res://Images/screenshot_%s_%s.png" % [date, time]
	# Wait for the next frame to render
	await RenderingServer.frame_post_draw
	# Grab the image, save it and free the SubViewport
	var img = sub_viewport.get_texture().get_image()
	img.save_png(screenshot_path)
	_addImageToJSON(screenshot_path)
	sub_viewport.queue_free()
	

func _addImageToJSON(screenshot_path: String):
	var json_file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ_WRITE)
	var arrayListmagesPath = JSON.parse_string(json_file.get_as_text())
	arrayListmagesPath.append(screenshot_path)
	json_file.store_string(JSON.stringify(arrayListmagesPath, "\t"))
	json_file.close()

func _fadeOut():
	var tween = get_tree().create_tween()
	tween.tween_property(screen_button, "modulate:a", 0, 1)
	tween.play()
	await tween.finished
	tween.kill()
	screen_button.add_theme_stylebox_override("normal").a = 1
	
