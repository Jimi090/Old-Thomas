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
var quest_index: int


func set_description():
	var done := int(progress.split("/")[0])
	var goal := int(progress.split("/")[1])

	label_1.text = description
	label_2.text = str(done) + "/" + str(goal)
	label_3.text = "Reward: " + str(int(reward)) + " gold"
	texture_rect.texture = load(texture)
	texture_rect.scale = texture_scale

	if done == goal:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func _on_pressed() -> void:
	var done := progress.split("/")[0]
	var goal := progress.split("/")[1]
	if done == goal:
		GameData.gold += reward
		GameData.quests[quest_index]["collected"] = true
		GameData.save_data()
		GameData.get_displaied_quests()
		get_tree().reload_current_scene()
