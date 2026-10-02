extends Node2D

@onready var label: Label = $Label

func setup(amount: int):
	label.text = "+" + str(amount) + " Gold"
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -40), 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.8)
	
	tween.chain().tween_callback(queue_free)
