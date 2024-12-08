extends Node

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")

const cardSize = Vector2(125, 187.50)

func set_border_image(type) -> String:
	if(type == "Normal"):
		return str("res://Assets/CardAssets/Borders/NormalBorder.png")
	elif(type == "Fast"):
		return str("res://Assets/CardAssets/Borders/FastBorder.png")
	elif(type == "Bait"):
		return  str("res://Assets/CardAssets/Borders/BaitBorder.png")
	return "Damn"

func get_total_amount_of_cards():
	var totalCardsCount: int = 0
	for key in userDeckResource.CardsStats.keys():
		var card = userDeckResource.CardsStats[key]
		totalCardsCount += card[8]
	print(totalCardsCount)
	return totalCardsCount
