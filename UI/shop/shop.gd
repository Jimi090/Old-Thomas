extends Control

@onready var items_container: Control = $Items_container
@onready var buy_btn: Button = $Buy_btn
@onready var gold_label: Label = $GoldLabel
@onready var description: Label = $Description
const GENERAL_POPUP = preload("uid://doyer7g4qd2mn")

var selected: Shop_item
var active_popup: GeneralPopup = null


func set_signals():
	for item: Shop_item in items_container.get_children():
		item.clicked.connect(_on_item_clicked)


func _on_item_clicked(item: Shop_item):
	if selected:
		selected.unselect()
	selected = item
	item.select()
	update_description()


func update_description():
	if GameData.upgrades[selected.name]["level"] < GameData.upgrades[selected.name]["maxLevel"]:
		description.text = selected.description + "\n\n" + "Cost: " + str(
			selected.costs[GameData.upgrades[selected.name]["level"]]
		)
	else:
		description.text = selected.description + "\n\n" + "MAX LEVEL"


func _ready() -> void:
	items_container.get_child(0).costs = GB.attack_upgrade.prices
	items_container.get_child(1).costs = GB.health_upgrade.prices
	items_container.get_child(2).costs = GB.speed_upgrade.prices
	items_container.get_child(3).costs = GB.revival_upgrade.prices

	set_signals()
	GameData.gold_changed.connect(_on_gold_changed)
	_on_gold_changed(GameData.gold)


func _on_buy_btn_pressed() -> void:
	if not selected:
		create_general_popup("", "Select an item first")
		return

	var currentlvl = int(GameData.upgrades[selected.name]["level"])

	if GameData.upgrades[selected.name]["level"] < GameData.upgrades[selected.name]["maxLevel"]:
		if GameData.gold >= selected.costs[currentlvl]:
			GameData.gold -= selected.costs[currentlvl]
			GameData.upgrades[selected.name]["level"] += 1
			update_description()
			selected.diamonds_amount_to_show += 1
			GameData.save_data()
		else:
			create_general_popup("", "You're too poor to buy this")


@warning_ignore("shadowed_variable")
func create_general_popup(title: String, description: String):
	if active_popup == null:
		var popup: GeneralPopup = GENERAL_POPUP.instantiate()
		popup.title_text = title
		popup.description_text = description

		add_child(popup)
		popup.position = (get_viewport_rect().size - popup.size) / 2
		popup.show()
		active_popup = popup


func _on_gold_changed(gold):
	gold_label.text = "Gold: " + str(gold)
