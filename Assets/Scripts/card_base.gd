extends MarginContainer

@onready var image: Sprite2D = $Image
@onready var border: Sprite2D = $Border
@onready var name_label: Label = $VBoxContainer/HoriziontalTop/Name/CenterContainer/NameLabel
@onready var attack_label: Label = $VBoxContainer/HoriziontalBot/Attack/CenterContainer/AttackLabel
@onready var cost_label: Label = $VBoxContainer/HoriziontalBot/Cost/CenterContainer/CostLabel
@onready var health_label: Label = $VBoxContainer/HoriziontalBot/Health/CenterContainer/HealthLabel

@onready var cardDatabase = preload("res://Assets/Database/CardDatabase.gd")
@onready var cardDatabaseInstance = cardDatabase.new()

var cardName = "Spy"

@onready var cardInfo = cardDatabaseInstance.DATA[cardDatabaseInstance.Cards.get(cardName)]
@onready var cardImage = str("res://Assets/Database/Units/",cardInfo[0],"/",cardName,".png")
@onready var cardType = cardInfo[4]
@onready var borderImage


func _ready():
	print(cardImage)
	print(cardInfo)
	
	# Setting border image and size
	set_border_image(cardType)
	border.texture = load(borderImage)
	border.scale *= size / border.texture.get_size()
	
	# Setting card image and size
	image.texture = load(cardImage)
	image.scale *= size / image.texture.get_size()
	
	# Setting card name, attack, cost and hp
	attack_label.text = str(cardInfo[1])
	health_label.text = str(cardInfo[2])
	name_label.text = str(cardInfo[3])
	cost_label.text = str(cardInfo[5])

func set_border_image(type):
	if(type == "normal"):
		borderImage = str("res://Assets/CardAssets/Borders/FastBorder.png")
	if(type == "fast"):
		borderImage = str("res://Assets/CardAssets/Borders/FastBorder.png")
	if(type == "bait"):
		borderImage = str("res://Assets/CardAssets/Borders/BaitBorder.png")

	
