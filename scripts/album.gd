extends Control

@onready var button_close := %ButtonClose

var _allImages: Array
@export var frameArray: Array[TextureRect]
var numberPages: int
var actualPage = 0
@export var buttonPreviousPage: Button
@export var buttonNextPage: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_close.pressed.connect(_on_button_close_pressed)
	_allImages = _load_json_file()
	_putImageOnPage(0)
	buttonPreviousPage.disabled = true

func _on_button_close_pressed() -> void:
	hide()

func _load_json_file() -> Array:
	print("on load")
	if not FileAccess.file_exists("res://scripts/listImagesAlbum.json"):
		print("File not found")
	var file = FileAccess.open("res://scripts/listImagesAlbum.json", FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	var listImages = JSON.parse_string(json_string)
	numberPages = int(listImages.size() / 2)
	print("liste de images")
	print(listImages)
	return listImages

func _putImageOnPage(actualPage: int) -> void:
	
	
	var index := actualPage * 2
	
	if (index < _allImages.size()):
		var file = FileAccess.open(_allImages[index], FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		var image = Image.new()
		var error = image.load_png_from_buffer(buffer)
		var texture = ImageTexture.create_from_image(image)
		frameArray[0].texture = texture
	if (index + 1 < _allImages.size()):
		var file = FileAccess.open(_allImages[index+1], FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		var image = Image.new()
		var error = image.load_png_from_buffer(buffer)
		var texture = ImageTexture.create_from_image(image)
		frameArray[1].texture = texture
	else:
		frameArray[1].texture = null
	
func _changePage(newPage: int):
	actualPage += newPage
	if (actualPage == 0):
		buttonPreviousPage.disabled = true
	else:
		buttonPreviousPage.disabled = false
	if (actualPage == numberPages):
		buttonNextPage.disabled = true
	else:
		buttonNextPage.disabled = false
	_putImageOnPage(actualPage)
	pass


func _on_previous_page_pressed() -> void:
	_changePage(-1)
	pass # Replace with function body.


func _on_next_page_pressed() -> void:
	_changePage(1)
	pass # Replace with function body.
