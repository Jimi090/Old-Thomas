extends Button

@export var path_number: int
@onready var padlock: TextureRect = $Padlock


func _ready() -> void:
	$Label.text = "Path " + str(path_number)
