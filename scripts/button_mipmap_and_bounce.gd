extends TextureButton

var bitmap: BitMap
var image: Image
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region bitmap handling
	bitmap = BitMap.new()
	image = texture_normal.get_image()
	if image.is_compressed():
		image.decompress()
	if flip_h: image.flip_x()
	if flip_v: image.flip_y()
	bitmap.create_from_image_alpha(image)
	texture_click_mask = bitmap
	#endregion

func _on_pressed() -> void:
	if tween:
		if tween.is_running(): return
		tween.kill()
	tween = get_tree().create_tween()
	
	tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.08).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_BOUNCE)
