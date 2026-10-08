extends Control

@onready var path_1: Button = $Path1
@onready var path_2: Button = $Path2
@onready var path_3: Button = $Path3
@onready var shop_btn: Button = $ShopBtn
@onready var church_btn: Button = $ChurchBtn

const SHOP = preload("uid://tf36yngqrqgr")
const TOWN = preload("uid://cqqlmplhsuk52")
const GENERAL_POPUP = preload("uid://doyer7g4qd2mn")


func _ready() -> void:
	shop_btn.pressed.connect(open_shop)
	church_btn.pressed.connect(open_town)
	path_1.pressed.connect(_on_click_path_button.bind(path_1.path_number))

	if is_path_finished("1") == true:
		path_2.pressed.connect(_on_click_path_button.bind(path_2.path_number))
	else:
		var title := "Path Locked"
		var desc := "Before you can enter this path, finish Path 1"
		path_2.pressed.connect(create_general_popup.bind(title, desc))
		path_2.padlock.visible = true

	if is_path_finished("2") == true:
		path_3.pressed.connect(_on_click_not_available)
	else:
		var title := "Path Locked"
		var desc := "Before you can enter this path, finish Path 2"
		path_3.pressed.connect(create_general_popup.bind(title, desc))
		path_3.padlock.visible = true


func is_path_finished(number: String):
	var finished := true

	for i in GameData.level_progress["Path" + number]:
		if GameData.level_progress["Path" + number][i]["finished"] == false:
			finished = false

	return finished


func _on_click_path_button(path_number: int):
	var lvlSelector = preload("res://UI/LevelSelector/LevelSelector.tscn").instantiate()
	lvlSelector.path = "Path" + str(path_number)
	get_tree().change_scene_to_node(lvlSelector)


func open_shop():
	var shop = SHOP.instantiate()
	get_tree().change_scene_to_node(shop)


func open_town():
	var town = TOWN.instantiate()
	get_tree().change_scene_to_node(town)


func create_general_popup(title: String, description: String):
	var popup: GeneralPopup = GENERAL_POPUP.instantiate()
	popup.title_text = title
	popup.description_text = description
	add_child(popup)
	popup.show()


func _on_click_not_available():
	var title := "Feature Not Available"
	var desc := "Sorry about that! We'll try to do better next time :)"
	create_general_popup(title, desc)
