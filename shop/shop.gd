extends Control

@onready var items_container: Control = $Items_container
@onready var buy_btn: Button = $Buy_btn
@onready var gold_label: Label = $GoldLabel
@onready var description: Label = $Description

var selected: Shop_item


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
	set_signals()
	GameData.gold_changed.connect(_on_gold_changed)
	_on_gold_changed(GameData.gold)


func _on_buy_btn_pressed() -> void:
	if not selected:
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
			print('xd')


func _on_gold_changed(gold):
	gold_label.text = "Gold: " + str(gold)
