extends MarginContainer

var userDeck : Deck

func _ready() -> void:
	userDeck = Deck.new()
	$HBoxContainer/VBoxContainer2/InfoMessage.hide()

func SwitchScene_test() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/card_base.tscn")

func SwitchSceneDeck() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/deck_menu.tscn")

func SwitchScenePack() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/pack_menu.tscn")
	
func SwitchSceneGame() -> void:
	$HBoxContainer/VBoxContainer/StartGame/Timer.start()
	if(userDeck.currentNrOfCards < 5):
		$HBoxContainer/VBoxContainer2/InfoMessage.show()
		$HBoxContainer/VBoxContainer2/InfoMessage.text = "Not enought cards in deck (min. 5)"
		return
	get_tree().change_scene_to_file("res://Assets/Scenes/game_screen.tscn")

func hide_text() -> void:
	$HBoxContainer/VBoxContainer2/InfoMessage.hide()
