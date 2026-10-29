extends TextureButton

var bitmap: BitMap
var image: Image

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
