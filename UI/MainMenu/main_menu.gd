extends Control

@onready var path_1: Button = $Path1
@onready var path_2: Button = $Path2
@onready var path_3: Button = $Path3
@onready var not_available_popup: Panel = $NotAvailablePopup
@onready var close_pupup_button: Button = $NotAvailablePopup/Button
@onready var shop_btn: Button = $ShopBtn
@onready var church_btn: Button = $ChurchBtn
const SHOP = preload("uid://tf36yngqrqgr")


func _ready() -> void:
	shop_btn.pressed.connect(open_shop)
	church_btn.pressed.connect(_on_click_not_available)
	path_1.pressed.connect(_on_click_path_button.bind(path_1.path_number))
	path_2.pressed.connect(_on_click_path_button.bind(path_2.path_number))
	path_3.pressed.connect(_on_click_not_available)


func _on_click_path_button(path_number: int):
	var lvlSelector = preload("res://UI/LevelSelector/LevelSelector.tscn").instantiate()
	lvlSelector.path = "Path" + str(path_number)
	get_tree().change_scene_to_node(lvlSelector)


func open_shop():
	var shop = SHOP.instantiate()
	get_tree().change_scene_to_node(shop)


func _on_click_not_available():
	not_available_popup.show()


func _on_button_pressed() -> void:
	not_available_popup.hide()
