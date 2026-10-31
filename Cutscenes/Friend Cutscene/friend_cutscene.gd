extends Control

@export_file("*.tscn") var village_scene: String = "res://UI/MainMenu/MainMenu.tscn"
@onready var story_label: Label = $StoryLabel
@onready var prompt_label: Label = $PromptLabel
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var pages: Array[String] = [
	"Once again Thomas has slayed the beast, and this time with his brand new companion.",
	"Right before heading back, he sees in the corner of his eye some trapped in a cage, likely one of the beast",
	"Heroicly, Thomas frees the person and they thank him. They share that if Thomas is every in the need for help to call him and he will help his new friend when in need",
]

var current_page: int = 0
var current_char: int = 0
var timer: float = 0.0
var letter_time: float = 0.03
var is_typing: bool = false


func _ready() -> void:
	if anim_player:
		anim_player.play("Scene1")

	if prompt_label:
		prompt_label.hide()
	story_label.text = ""
	current_page = 0
	current_char = 0
	is_typing = true


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
			if prompt_label:
				prompt_label.show()


func _input(event: InputEvent) -> void:
	if not is_typing and (event.is_action_pressed("ui_accept") or event.is_action_pressed("jump")):
		current_page += 1
		if current_page < pages.size():
			story_label.text = ""
			current_char = 0
			timer = 0.0
			is_typing = true
			if prompt_label:
				prompt_label.hide()
			if current_page == 1 and anim_player:
				anim_player.play("Scene2")
			if current_page == 2 and anim_player:
				anim_player.play("Scene3")
		else:
			go_to_village()
	if event.is_action_pressed("down"):
		go_to_village()


func go_to_village() -> void:
	if village_scene:
		get_tree().change_scene_to_file(village_scene)
	else:
		print("Error: Village scene path not assigned!")
