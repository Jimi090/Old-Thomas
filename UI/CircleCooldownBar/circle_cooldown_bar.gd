extends Control

@onready var texture_rect: TextureRect = $TextureRect

var radius := 4.0
var thickness := 1.0

var cooldown: float
var cooldown_remaining: float


func _ready() -> void:
	cooldown_remaining = cooldown
	texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	queue_redraw()


func _process(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining = max(0.0, cooldown_remaining - delta)
		queue_redraw()
	else:
		texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _draw() -> void:
	var center = size / 2
	var offset := -PI / 2

	if cooldown_remaining > 0.0:
		draw_arc(
			center,
			radius,
			offset,
			cooldown_remaining / cooldown * -TAU + offset,
			100,
			Color.ROYAL_BLUE,
			thickness,
		)


func restart():
	cooldown_remaining = cooldown
