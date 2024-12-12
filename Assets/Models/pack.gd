extends Node
class_name Pack

var packsProbabilities: Dictionary
var userDeck: Deck

func _init():
	userDeck = Deck.new()
	var path = "res://Assets/Database/Pack/"
	var dir = DirAccess.get_files_at("res://Assets/Database/Pack/")
	for item in dir:
		if(str(item) == "Packs.gd"):
			continue
		var res : PacksResource = load(path+item)
		packsProbabilities[res.PackName] = res.PackChance
	var packsProbabilitiesKeys = packsProbabilities.keys()
	var packsProbabilitiesValue = packsProbabilities.values()
	packsProbabilitiesValue.sort()
	packsProbabilitiesKeys.sort_custom(func(x: String, y: String)-> bool: return packsProbabilities[x] > packsProbabilities[y])
	packsProbabilities.clear()
	packsProbabilitiesValue.reverse()
	var culm = 0
	for i in range(0,packsProbabilitiesValue.size()):
		culm += packsProbabilitiesValue[i]
		packsProbabilities[packsProbabilitiesKeys[i]] = culm

func open_pack() -> Array:
	var random = randi_range(1,100)
	var cardKey
	var packName
	for item in packsProbabilities:
		var value = packsProbabilities[item]
		if(random <= value):
			cardKey = get_card(item)
			packName = item
			break
	if(userDeck.userDeckResource.CardsStats.has(cardKey)):
		userDeck.userDeckResource.CardsStats[cardKey][7] += 1
	else:
		var cardDatabaseRes : userCardsResource = load("res://Assets/Database/CardDatabase.tres")
		userDeck.userDeckResource.CardsStats[cardKey] = []
		userDeck.userDeckResource.CardsStats[cardKey].resize(9)
		for i in range(7):
			userDeck.userDeckResource.CardsStats[cardKey][i] = cardDatabaseRes.CardsStats[cardKey][i]
		userDeck.userDeckResource.CardsStats[cardKey][7] = 1
		userDeck.userDeckResource.CardsStats[cardKey][8] = 0
	ResourceSaver.save(userDeck.userDeckResource,"res://Assets/Database/User/UserCardRes.tres")
	return [packName, userDeck.userDeckResource.CardsStats[cardKey][0]]

func get_card(packKey : String) -> String:
	var packRes : PacksResource = load("res://Assets/Database/Pack/" + packKey + ".tres")
	var random = randi_range(0,packRes.PackCards.size()-1)
	var cardKey = packRes.PackCards[random]
	return cardKey
