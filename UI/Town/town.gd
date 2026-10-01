extends Control

@onready var quest_1: Quest = $Scroll/QuestContainer/Quest1
@onready var quest_2: Quest = $Scroll/QuestContainer/Quest2
@onready var quest_3: Quest = $Scroll/QuestContainer/Quest3


func _ready() -> void:
	quest_1.description = GameData.quests[GameData.displaied_quests["kill"]]["description"]
	quest_1.progress = str(GameData.quests[GameData.displaied_quests["kill"]]["progress"]) + "/" + str(
		GameData.quests[GameData.displaied_quests["kill"]]["goal"]
	)
	quest_1.reward = GameData.quests[GameData.displaied_quests["kill"]]["reward"]
	quest_1.texture = "res://UI/Town/assets/enemy.png"
	quest_1.texture_scale = Vector2(32, 32)
	quest_1.quest_index = GameData.displaied_quests["kill"]
	quest_1.set_description()

	###
	quest_2.description = GameData.quests[GameData.displaied_quests["path"]]["description"]
	quest_2.progress = str(GameData.quests[GameData.displaied_quests["path"]]["progress"]) + "/" + str(
		GameData.quests[GameData.displaied_quests["path"]]["goal"]
	)
	quest_2.reward = GameData.quests[GameData.displaied_quests["path"]]["reward"]
	quest_2.texture = "res://UI/Town/assets/signpost.png"
	quest_2.texture_scale = Vector2(12, 12)
	quest_2.quest_index = GameData.displaied_quests["path"]
	quest_2.set_description()

	###
	quest_3.description = GameData.quests[GameData.displaied_quests["collect"]]["description"]
	quest_3.progress = str(GameData.quests[GameData.displaied_quests["collect"]]["progress"]) + "/" + str(
		GameData.quests[GameData.displaied_quests["collect"]]["goal"]
	)
	quest_3.reward = GameData.quests[GameData.displaied_quests["collect"]]["reward"]
	quest_3.texture = "res://UI/Town/assets/coin-Sheet.png"
	quest_3.texture_scale = Vector2(24, 24)
	quest_3.quest_index = GameData.displaied_quests["collect"]
	quest_3.set_description()
