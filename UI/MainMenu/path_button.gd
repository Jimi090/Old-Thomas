extends Button

@export var path_number: int


func _ready() -> void:
	$Label.text = "Path " + str(path_number)
