extends MarginContainer

var pack : Pack

@onready var acquiredCard : Label = $HBoxContainer/VBoxContainer2/AcquiredCard
@onready var acquiredPack : Label = $HBoxContainer/VBoxContainer2/AcquiredPack
@onready var currency : Label = $VBoxContainer3/Currency

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

func _ready() -> void:
	pack = Pack.new()
	currency.text = str(pack.userDeck.userDeckResource.playerCurrency)

func OpenPack() -> void:
	var returnVal = pack.open_pack()
	if(returnVal[0] == ""):
		acquiredPack.label_settings.font_color = Color.WHITE
		acquiredPack.text = returnVal[1]
		acquiredCard.hide()
		return
	acquiredCard.text = returnVal[1]
	acquiredPack.text = returnVal[0]
	currency.text = str(pack.userDeck.userDeckResource.playerCurrency)
	acquiredCard.label_settings.font_color = Global.get_pack_rarity_color(returnVal[0])
	acquiredPack.label_settings.font_color = Global.get_pack_rarity_color(returnVal[0])

func SwitchSceneMainMenu() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
