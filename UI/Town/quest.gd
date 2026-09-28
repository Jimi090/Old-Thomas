extends Control

@onready var scroll: TextureRect = $Scroll
@onready var label: Label = $Label

@export var description := "Kill 10 shadows"
@export var reward := 10


func _ready() -> void:
	label.text = description + "\nReward: " + str(reward)
