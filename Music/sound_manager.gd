extends AudioStreamPlayer

var coinsnd = preload("res://Music/assets/coinsound.mp3")
var deathsnd = preload("res://Music/assets/deathsound.mp3")
var buttonsnd = preload("res://Music/assets/buttonsound.mp3") 

func _ready():
	get_tree().node_added.connect(_on_node_added)
	await get_tree().process_frame 
	connect_existing_buttons(get_tree().root)

func connect_existing_buttons(node: Node):
	if node is BaseButton:
		if not node.pressed.is_connected(play_button_sound):
			node.pressed.connect(play_button_sound)
	
	for child in node.get_children():
		connect_existing_buttons(child)
		

func _on_node_added(node: Node):
	if node is BaseButton:
		if not node.pressed.is_connected(play_button_sound):
			node.pressed.connect(play_button_sound)

func play_coin_sound():
	stream = coinsnd
	volume_db = 0.0
	play()
	
func play_death_sound(): 
	stream = deathsnd
	volume_db = 10.0
	play()
	
func play_button_sound():
	stream = buttonsnd
	volume_db = 5.0
	play()
