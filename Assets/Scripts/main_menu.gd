extends MarginContainer


func SwitchScene_test() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/card_base.tscn")

func SwitchSceneDeck() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/deck_menu.tscn")

func SwitchScenePack() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/pack_menu.tscn")
	
func SwitchSceneGame() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/game_screen.tscn")
