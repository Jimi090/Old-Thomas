class_name Quest
extends Button

@onready var scroll: TextureRect = $Scroll
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var texture_rect: TextureRect = $TextureRect

var description: String
var reward: int
var progress: String
var texture := "res://UI/Town/assets/enemy.png"
var texture_scale := Vector2(32, 32)


func set_description():
	label_1.text = description
	label_2.text = progress
	label_3.text = "Reward: " + str(reward) + " gold"
	texture_rect.texture = load(texture)
	texture_rect.scale = texture_scale
