extends MarginContainer
@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel

var game_won: bool

func display_game_result():
	self.show()
	if(game_won):
		rich_text_label.text = "[center][font_size=60][wave amp=50.0 freq=5.0 connected=1][color=#00FF00]WINNER[/color][/wave][/font_size][/center]"
	else:
		rich_text_label.text = "[center][font_size=60][wave amp=50.0 freq=5.0 connected=1][color=#FF0000]LOOSER[/color][/wave][/font_size][/center]"
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
