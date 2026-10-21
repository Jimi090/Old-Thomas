extends Control

@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	update_progress_bar()


func update_progress_bar():
	for path in GameData.level_progress:
		pass
