extends Node


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_killed)
	Events.level_completed.connect(_on_level_completion)
	Events.coin_collected.connect(_on_coin_collection)


func _on_enemy_killed():
	GameData.quests[GameData.active_quests["kill"]]["progress"] += 1
	check_if_quest_completed(GameData.quests[GameData.active_quests["kill"]])
	GameData.save_data()


func _on_level_completion(path, level):
	if level not in GameData.quests[GameData.active_quests["path"]]["levels_beaten"]:
		GameData.quests[GameData.active_quests["path"]]["levels_beaten"].append(level)
		GameData.quests[GameData.active_quests["path"]]["progress"] += 1
	'GameData.quests[GameData.active_quests["path"]]["completed"] = true
	GameData.get_active_quests()
	GameData.save_data()'


func _on_coin_collection():
	GameData.quests[GameData.active_quests["collect"]]["progress"] += 1
	check_if_quest_completed(GameData.quests[GameData.active_quests["collect"]])
	GameData.save_data()


func check_if_quest_completed(quest):
	if quest["progress"] >= quest["goal"]:
		quest["completed"] = true
		GameData.get_active_quests()
