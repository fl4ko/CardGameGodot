extends MarginContainer

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")

@onready var image: TextureRect = $VBoxContainer2/HBoxContainer/CardContainer/Image
@onready var border: TextureRect = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border
@onready var cardName: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/NameRect/NameLabel
@onready var attack: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/AttackRect/AttackLabel
@onready var cost: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/CostRect/CostLabel
@onready var health: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/HealthRect/HealthLabel
@onready var userCardMax: Label = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer/UserCardMax
@onready var userCardDeck: Label = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer/UserCardDeck
@onready var cardNamesList : ItemList = $VBoxContainer2/HBoxContainer/ScrollContainer/CardNamesList
@onready var cardCointainer : HBoxContainer = $VBoxContainer2/HBoxContainer/CardContainer
@onready var add : Button = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer2/Add
@onready var remove : Button = $VBoxContainer2/HBoxContainer/GridContainer/HBoxContainer2/Remove

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

var cardInfo
var cardKey

func _ready() -> void:
	for key in userDeckResource.CardsStats.keys():
		cardInfo = userDeckResource.CardsStats[key]
		cardNamesList.add_item(cardInfo[0])
	image.hide()
	add.hide()
	remove.hide()

func cardChosen(index: int) -> void:
	cardKey = cardNamesList.get_item_text(index) as String
	cardKey = cardKey.replace(" ","")
	cardKey = cardKey.replace("-","")
	cardInfo = userDeckResource.CardsStats[cardKey]
	image.texture = load(cardInfo[6])
	var borderImage = set_border_image(cardInfo[2])
	border.texture = load(borderImage)
	image.show()
	add.show()
	remove.show()
	attack.text = str(cardInfo[5])
	cost.text = str(cardInfo[3])
	health.text = str(cardInfo[4])
	cardName.text = cardInfo[0]
	userCardMax.text = "Avaliable Cards: " + str(cardInfo[7])
	userCardDeck.text = "In Deck: " + str(cardInfo[8])
	
func cardAdded() -> void:
	if(userDeckResource.CardsStats[cardKey][8] >= 3 || 
	userDeckResource.CardsStats[cardKey][8] >= userDeckResource.CardsStats[cardKey][7]):
		return
	userDeckResource.CardsStats[cardKey][8] += 1
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	userCardDeck.text = "In Deck: " + str(cardInfo[8])
	
func cardRemoved() -> void:
	if(userDeckResource.CardsStats[cardKey][8] <= 0):
		return
	userDeckResource.CardsStats[cardKey][8] -= 1
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	userCardDeck.text = "In Deck: " + str(cardInfo[8])

func set_border_image(type) -> String:
	if(type == "Normal"):
		return str("res://Assets/CardAssets/Borders/NormalBorder.png")
	elif(type == "Fast"):
		return str("res://Assets/CardAssets/Borders/FastBorder.png")
	elif(type == "Bait"):
		return  str("res://Assets/CardAssets/Borders/BaitBorder.png")
	return "Damn"
	
func SwitchSceneMainMenu() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
