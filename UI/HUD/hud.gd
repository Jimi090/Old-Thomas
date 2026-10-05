extends CanvasLayer

@export var player: Player

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var gold_label: Label = $UI/GoldLabel


func _on_gold_changed(amount):
	gold_label.text = "Gold: " + str(amount)


func _on_health_changed(health):
	health_bar.value = health
	var percent = float(health) / player.MAX_HEALTH * 100

	var style := health_bar.get_theme_stylebox("fill").duplicate()

	if percent >= 60:
		style.bg_color = "#32CD32"
	elif percent >= 30:
		style.bg_color = "#FFD700"
	else:
		style.bg_color = "#FF3B30"

	health_bar.add_theme_stylebox_override("fill", style)


func _ready() -> void:
	GameData.gold_changed.connect(_on_gold_changed)
	player.health_changed.connect(_on_health_changed)

	health_bar.max_value = player.MAX_HEALTH
	health_bar.value = player.MAX_HEALTH

	gold_label.text = "Gold: " + str(GameData.gold)
