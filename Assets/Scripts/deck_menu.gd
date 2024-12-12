extends MarginContainer

@onready var userDeck : Deck

@onready var userCardMax: Label = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer/UserCardMax
@onready var userCardDeck: Label = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer/UserCardDeck
@onready var cardNamesList : ItemList = $VBoxContainer2/HBoxContainer/ScrollContainer/CardNamesList
@onready var cardBase: Card = $VBoxContainer2/HBoxContainer/CardBase
@onready var add : Button = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer2/Add
@onready var remove : Button = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer2/Remove
@onready var userCardDeckTimer : Timer = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer/UserCardDeckTimer

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

var cardInfo
var cardKey

func _ready() -> void:
	userDeck = Deck.new()
	for key in userDeck.userDeckResource.CardsStats.keys():
		cardInfo = userDeck.userDeckResource.CardsStats[key]
		cardNamesList.add_item(cardInfo[0])
	cardBase.image.hide()
	cardBase.is_player = false
	add.hide()
	remove.hide()
	userCardMax.hide()
	userCardDeck.hide()

func cardChosen(index: int) -> void:
	cardKey = cardNamesList.get_item_text(index) as String
	cardKey = cardKey.replace(" ","")
	cardKey = cardKey.replace("-","")
	cardInfo = userDeck.get_card_info(cardKey)
	cardBase.cardName = cardInfo[0]
	cardBase.image.texture = load(cardInfo[6])
	var borderImage = Global.set_border_image(cardInfo[2])
	cardBase.border.texture = load(borderImage)
	cardBase.image.show()
	add.show()
	remove.show()
	userCardMax.show()
	userCardDeck.show()
	cardBase.attack_label.text = str(cardInfo[5])
	cardBase.cost_label.text = str(cardInfo[3])
	cardBase.health_label.text = str(cardInfo[4])
	cardBase.name_label.text = cardInfo[0]
	userCardMax.text = "Avaliable Cards: " + str(cardInfo[7])
	userCardDeck.text = "In Deck: " + str(cardInfo[8])
	
func cardAdded() -> void:
	userCardDeck.text = userDeck.add_card(cardKey)
	userCardDeckTimer.start()
	
func cardRemoved() -> void:
	userCardDeck.text = userDeck.remove_card(cardKey)
	userCardDeckTimer.start()

func show_cards_in_deck() -> void:
	userCardDeck.text = "In Deck: " + str(cardInfo[8])

func clear_deck() -> void:
	userDeck.clear_all_cards_from_deck()
	cardBase.image.hide()
	add.hide()
	remove.hide()
	userCardMax.hide()
	userCardDeck.hide()
	
func delete_deck() -> void:
	userDeck.delete_everything_from_deck()
	cardBase.image.hide()
	add.hide()
	remove.hide()
	userCardMax.hide()
	userCardDeck.hide()
	cardNamesList.clear()

func SwitchSceneMainMenu() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
