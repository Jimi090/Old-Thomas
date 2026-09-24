extends Control

@export_file("*.tscn") var village_scene: String = "res://UI/MainMenu/MainMenu.tscn"
@onready var story_label: Label = $StoryLabel

var pages: Array[String] = [
	"Though his hair has turned gray and the years have grown long behind him, Thomas realizes his life story is still unfinished.",
	"Leaving the comfort of his quiet home, he steps onto unfamiliar paths, seeking a deeper evolution.",
	"He searches not for gold or glory, but for a lost feeling, a deep truth, or a companion to help him truly change before his journey ends.",
]

var current_page: int = 0
var current_char: int = 0
var timer: float = 0.0
var letter_time: float = 0.03
var is_typing: bool = false
var block_input_momentarily: bool = false


func _ready() -> void:
	story_label.text = ""
	show_page(0)


func show_page(index: int) -> void:
	if index < pages.size():
		current_page = index
		story_label.text = ""
		current_char = 0
		timer = 0.0
		is_typing = true
		block_input_momentarily = true

		await get_tree().process_frame
		block_input_momentarily = false
	else:
		go_to_village()


func _process(delta: float) -> void:
	if is_typing:
		var target_text = pages[current_page]
		if current_char < target_text.length():
			timer += delta
			if timer >= letter_time:
				timer = 0.0
				current_char += 1
				story_label.text = target_text.substr(0, current_char)
		else:
			is_typing = false


func _input(event: InputEvent) -> void:
	if block_input_momentarily:
		return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		if is_typing:
			story_label.text = pages[current_page]
			current_char = pages[current_page].length()
			is_typing = false
		else:
			show_page(current_page + 1)


func go_to_village() -> void:
	if village_scene:
		get_tree().change_scene_to_file(village_scene)
	else:
		print("Error: Main Scen path wasn't  assigned!")
