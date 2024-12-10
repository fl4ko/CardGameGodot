extends MarginContainer

var pack : Pack

@onready var acquiredCard : Label = $HBoxContainer/VBoxContainer2/AcquiredCard
@onready var acquiredPack : Label = $HBoxContainer/VBoxContainer2/AcquiredPack


# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

func _ready() -> void:
	pack = Pack.new()

func OpenPack() -> void:
	var returnVal = pack.open_pack()
	acquiredCard.text = returnVal[1]
	acquiredPack.text = returnVal[0]
	acquiredCard.label_settings.font_color = Global.get_pack_rarity_color(returnVal[0])
	acquiredPack.label_settings.font_color = Global.get_pack_rarity_color(returnVal[0])

func SwitchSceneMainMenu() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
