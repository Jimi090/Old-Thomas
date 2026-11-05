extends Button

@export var path_number: int
@onready var padlock: TextureRect = $Padlock

var color := Color.YELLOW


func _ready() -> void:
	$Label.text = "Path " + str(path_number)
	if path_number == 4 and GameData.progress >= 75 and GameData.progress < 100:
		$Label.add_theme_color_override("font_color", color)
	elif path_number == 3 and GameData.progress >= 50 and GameData.progress < 75:
		$Label.add_theme_color_override("font_color", color)
	elif path_number == 2 and GameData.progress >= 25 and GameData.progress < 50:
		$Label.add_theme_color_override("font_color", color)
	elif path_number == 1 and GameData.progress >= 0 and GameData.progress < 25:
		$Label.add_theme_color_override("font_color", color)
