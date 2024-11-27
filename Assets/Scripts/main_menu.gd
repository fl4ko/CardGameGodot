extends MarginContainer


func SwitchScene_test() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/card_base.tscn")

func SwitchSceneDeck() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/deck_menu.tscn")
