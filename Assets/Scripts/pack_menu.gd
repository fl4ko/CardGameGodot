extends MarginContainer

@onready var acquiredCard : Label = $HBoxContainer/VBoxContainer2/AcquiredCard
@onready var acquiredPack : Label = $HBoxContainer/VBoxContainer2/AcquiredPack

var packsProbabilities : Dictionary

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

func _ready() -> void:
	var path = "res://Assets/Database/Pack/"
	var dir = DirAccess.get_files_at("res://Assets/Database/Pack/")
	var cumulative = 0
	for item in dir:
		if(str(item) == "Packs.gd"):
			continue
		var res : packsResource = load(path+item)
		cumulative += res.PackChance
		packsProbabilities[res.PackName] = cumulative

func OpenPack() -> void:
	var random = randi_range(1,100)
	var minimum = packsProbabilities.values()
	minimum.sort()
	var cardKey
	var packName
	for item in packsProbabilities:
		var value = packsProbabilities[item]
		if(random <= value):
			cardKey = GetCard(item)
			packName = item
			break
	var userCardRes : userCardsResource = load("res://Assets/Database/User/UserCardRes.tres")
	if(userCardRes.CardsStats.has(cardKey)):
		userCardRes.CardsStats[cardKey][7] += 1
	else:
		var cardDatabaseRes : userCardsResource = load("res://Assets/Database/CardDatabase.tres")
		userCardRes.CardsStats[cardKey] = []
		userCardRes.CardsStats[cardKey].resize(9)
		for i in range(7):
			userCardRes.CardsStats[cardKey][i] = cardDatabaseRes.CardsStats[cardKey][i]
		userCardRes.CardsStats[cardKey][7] = 1
		userCardRes.CardsStats[cardKey][8] = 0
	acquiredPack.text = packName
	acquiredCard.text = userCardRes.CardsStats[cardKey][0]
	ResourceSaver.save(userCardRes,"res://Assets/Database/User/UserCardRes.tres")

func GetCard(packKey : String) -> String:
	var packRes : packsResource = load("res://Assets/Database/Pack/" + packKey + ".tres")
	var random = randi_range(0,packRes.PackCards.size()-1)
	var cardKey = packRes.PackCards[random]
	return cardKey

func SwitchSceneMainMenu() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/main_menu.tscn")
