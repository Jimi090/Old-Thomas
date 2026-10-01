extends Node


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_killed)
	Events.level_completed.connect(_on_level_completion)
	Events.level_completed.emit()


func _on_enemy_killed():
	GameData.quests[GameData.active_quests["kill"]]["progress"] += 1
	check_if_quest_completed(GameData.quests[GameData.active_quests["kill"]])
	GameData.save_data()


func _on_level_completion():
	for path in GameData.level_progress:
		var path_number: int = int(path[-1])
		if is_path_completed(path_number):
			GameData.quests[GameData.active_quests["path"]]["completed"] = true
			GameData.get_active_quests()
			GameData.save_data()


func is_path_completed(path_number):
	var is_good := true
	for level_name in GameData.level_progress["Path" + str(path_number)]:
		var level = GameData.level_progress["Path" + str(path_number)][level_name]
		if level["finished"] == false:
			is_good = false
	return is_good


func check_if_quest_completed(quest):
	if quest["progress"] >= quest["goal"]:
		quest["completed"] = true
		GameData.get_active_quests()
