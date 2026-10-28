extends Label

@export_multiline var text_to_show: String = "Though his hair has turned gray and the years have grown long behind him, Thomas realizes his life story is still unfinished..."
@export var letter_time: float = 0.03 

var current_char: int = 0
var timer: float = 0.0

func _ready() -> void:
	text = "" 

func _process(delta: float) -> void:
	if current_char < text_to_show.length():
		timer += delta
		if timer >= letter_time:
			timer = 0.0
			current_char += 1
			text = text_to_show.substr(0, current_char)
