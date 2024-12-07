extends HBoxContainer
class_name Card

@onready var cards: userCardsResource = preload("res://Assets/Database/CardDatabase.tres")

@onready var border: TextureRect = $Image/Border
@onready var image: TextureRect = $Image
@onready var attack_label: Label = $Image/Border/AttackRect/AttackLabel
@onready var cost_label: Label = $Image/Border/CostRect/CostLabel
@onready var health_label: Label = $Image/Border/HealthRect/HealthLabel
@onready var name_label: Label = $Image/Border/NameRect/NameLabel

var cardName = "PoorInfantryman"

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image

@onready var borderImage

@export var Name: String
@export var Health: int
@export var Attack: int
@export var Cost: int


func _ready():

	cardName = cardName.replace(" ","")
	cardName = cardName.replace("-","")
	var cardInfo = cards.CardsStats.get(cardName)
	var cardImage = cardInfo[6]
	var cardType = cardInfo[2]
	
	print(cardImage)
	print(cardInfo)
	
	# Setting border image and size
	set_border_image(cardType)
	border.texture = load(borderImage)
	#border.scale *= size / border.texture.get_size()
	
	# Setting card image and size
	image.texture = load(cardImage)
	#image.scale *= size / image.texture.get_size()
	
	# Setting card name, attack, cost and hp
	attack_label.text = str(cardInfo[5])
	health_label.text = str(cardInfo[4])
	name_label.text = str(cardInfo[0])
	cost_label.text = str(cardInfo[3])

func set_border_image(type):
	if(type == "Normal"):
		borderImage = str("res://Assets/CardAssets/Borders/NormalBorder.png")
	if(type == "Fast"):
		borderImage = str("res://Assets/CardAssets/Borders/FastBorder.png")
	if(type == "Bait"):
		borderImage = str("res://Assets/CardAssets/Borders/BaitBorder.png")

	
