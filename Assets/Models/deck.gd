extends Node
class_name Deck

@onready var userDeckResource : userCardsResource

var currentHand: Array
var maxNrOfCards
var currentNrOfCards

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image, 7HowManyCardsUserHas, 8CardsInDeck

func _init():
	userDeckResource = load("res://Assets/Database/User/UserCardRes.tres")
	currentNrOfCards = 0
	for item in userDeckResource.CardsStats:
		currentNrOfCards += userDeckResource.CardsStats[item][8]
	maxNrOfCards = 20
	for key in userDeckResource.CardsStats.keys():
		var card = userDeckResource.CardsStats[key]
		var amountInDeck = card[8]
		if amountInDeck > 0:
			for i in range(amountInDeck):
				currentHand.append(userDeckResource.CardsStats[key])

func get_card_info(cardKey : String) -> Array:
	return userDeckResource.CardsStats[cardKey]

func add_card(cardKey: String) -> String:
	if(userDeckResource.CardsStats[cardKey][8] >= 3 || 
	userDeckResource.CardsStats[cardKey][8] >= userDeckResource.CardsStats[cardKey][7] ||
	currentNrOfCards >= maxNrOfCards):
		return "Can't add more"
	userDeckResource.CardsStats[cardKey][8] += 1
	currentNrOfCards += 1
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	return "In Deck: " + str(userDeckResource.CardsStats[cardKey][8])

func remove_card(cardKey: String) -> String:
	if(userDeckResource.CardsStats[cardKey][8] <= 0):
		return "Can't remove more"
	userDeckResource.CardsStats[cardKey][8] -= 1
	currentNrOfCards -= 1
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	return "In Deck: " + str(userDeckResource.CardsStats[cardKey][8])

func clear_all_cards_from_deck() -> void:
	for item in userDeckResource.CardsStats:
		userDeckResource.CardsStats[item][8] = 0
	currentNrOfCards = 0
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	
func delete_everything_from_deck() -> void:
	userDeckResource.CardsStats = {}
	ResourceSaver.save(userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
