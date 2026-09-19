extends Control

@onready var path_1: Button = $Path1
@onready var not_available_popup: AcceptDialog = $NotAvailablePopup
@onready var shop_btn: Button = $ShopBtn
@onready var church_btn: Button = $ChurchBtn


func _ready() -> void:
	path_1.pressed.connect(_on_click_path1)
	shop_btn.pressed.connect(_on_click_not_available)
	church_btn.pressed.connect(_on_click_not_available)
	$Path2.pressed.connect(_on_click_not_available)
	$Path3.pressed.connect(_on_click_not_available)


func _on_click_path1():
	var lvlSelector = preload("res://UI/LevelSelector/LevelSelector.tscn").instantiate()
	get_tree().change_scene_to_node(lvlSelector)


func _on_click_not_available():
	not_available_popup.popup_centered()
	not_available_popup.show()
