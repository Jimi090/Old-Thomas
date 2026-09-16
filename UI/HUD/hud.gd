extends CanvasLayer

@export var player: Player

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var gold_label: Label = $UI/GoldLabel


func _on_gold_changed(amount):
	gold_label.text = "Gold: " + str(amount)


func _on_health_changed(health):
	health_bar.value = health


func _ready() -> void:
	GameData.gold_changed.connect(_on_gold_changed)
	player.health_changed.connect(_on_health_changed)

	health_bar.max_value = player.max_health
	health_bar.value = player.max_health
