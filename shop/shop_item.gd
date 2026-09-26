class_name Shop_item
extends Panel

@export var button_image := preload("uid://cuxtpttm6sod2")
@onready var diamonds_container: HBoxContainer = $DiamondsContainer
@onready var button: Button = $Button

@export var description: String
@export var costs: Array[int]

var diamonds_amount_to_show := 0:
	set(value):
		show_diamonds(value)
		diamonds_amount_to_show = value

var selected := false:
	set(value):
		if value == true:
			select()
		else:
			unselect()
		selected = value

signal clicked(item)


func _on_shop_item_pressed() -> void:
	clicked.emit(self)


func _ready() -> void:
	button.icon = button_image
	GameData.upgrades_changed.connect(update_diamonds)
	update_diamonds()


func select():
	var style := get_theme_stylebox("panel").duplicate()
	var border_width := 6
	style.border_width_left = border_width
	style.border_width_right = border_width
	style.border_width_top = border_width
	style.border_width_bottom = border_width
	add_theme_stylebox_override("panel", style)


func unselect():
	var style := get_theme_stylebox("panel").duplicate()
	style.border_width_left = 0
	style.border_width_right = 0
	style.border_width_top = 0
	style.border_width_bottom = 0
	add_theme_stylebox_override("panel", style)


func update_diamonds():
	diamonds_amount_to_show = int(GameData.upgrades[name]["level"])


func show_diamonds(amount):
	var counter = 0
	for body in diamonds_container.get_children():
		if counter < amount:
			body.show()
		counter += 1
