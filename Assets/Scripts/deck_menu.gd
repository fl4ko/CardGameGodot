extends MarginContainer

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")

@onready var image: TextureRect = $VBoxContainer2/HBoxContainer/CardContainer/Image
@onready var border: TextureRect = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border
@onready var cardName: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/NameRect/NameLabel
@onready var attack: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/AttackRect/AttackLabel
@onready var cost: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/CostRect/CostLabel
@onready var health: Label = $VBoxContainer2/HBoxContainer/CardContainer/Image/Border/HealthRect/HealthLabel
@onready var cardNamesList : ItemList = $VBoxContainer2/HBoxContainer/ScrollContainer/CardNamesList
@onready var cardCointainer : HBoxContainer = $VBoxContainer2/HBoxContainer/CardContainer

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image

func _ready() -> void:
	for key in userDeckResource.CardsStats.keys():
		var cardInfo = userDeckResource.CardsStats[key]
		cardNamesList.add_item(cardInfo[0])
	image.hide()

func cardChosen(index: int) -> void:
	var cardKey := cardNamesList.get_item_text(index) as String
	cardKey = cardKey.replace(" ","")
	var cardInfo = userDeckResource.CardsStats[cardKey]
	image.texture = load(cardInfo[6])
	var borderImage = set_border_image(cardInfo[2])
	border.texture = load(borderImage)
	image.show()
	attack.text = str(cardInfo[5])
	cost.text = str(cardInfo[3])
	health.text = str(cardInfo[4])
	cardName.text = cardInfo[0]
	

func set_border_image(type) -> String:
	if(type == "Normal"):
		return str("res://Assets/CardAssets/Borders/NormalBorder.png")
	elif(type == "Fast"):
		return str("res://Assets/CardAssets/Borders/FastBorder.png")
	elif(type == "Bait"):
		return  str("res://Assets/CardAssets/Borders/BaitBorder.png")
	return "Damn"
