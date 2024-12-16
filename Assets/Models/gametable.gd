extends Node
class_name GameTable

@onready var player: Player
@onready var enemy: Player

func _init() -> void:
	player = Player.new()
	enemy = Player.new()
	
func get_best_card() -> Array:
	if(enemy.userDeck.currentHand.size() <= 0):
		return []
	var itemMaxCount = enemy.userDeck.currentHand.size()
	var MaxWeight = enemy.current_mana
	var Backpack = []
	for x in range(0, MaxWeight + 1):
		var _row = []
		_row.resize(itemMaxCount + 1)
		_row.fill(false)
		Backpack.append(_row)
	var cardTable = enemy.userDeck.currentHand
	var cardsToPick = []
	var indexesToRemove = []
	
	for currentWeight in range(0,MaxWeight+1):
		for currentItem in range(0,itemMaxCount+1):
			if currentItem == 0 or currentWeight == 0:
				Backpack[currentWeight][currentItem] = 0
			elif cardTable[currentItem - 1].Cost <= currentWeight:
				var avgCardStats = floor((cardTable[currentItem - 1].Attack + cardTable[currentItem - 1].Health) / 2)
				if avgCardStats + Backpack[currentWeight - cardTable[currentItem - 1].Cost][currentItem - 1] > Backpack[currentWeight][currentItem - 1]:
					Backpack[currentWeight][currentItem] = avgCardStats + Backpack[currentWeight - cardTable[currentItem - 1].Cost][currentItem - 1]
				else:
					Backpack[currentWeight][currentItem] = Backpack[currentWeight][currentItem - 1]
			else:
				Backpack[currentWeight][currentItem] = Backpack[currentWeight][currentItem - 1]
	var weight = MaxWeight;
	for i in range(itemMaxCount, 0, -1):
		if Backpack[weight][i] != Backpack[weight][i - 1]:
			cardsToPick.append(cardTable[i - 1])
			indexesToRemove.append(i - 1)
			weight -= cardTable[i - 1].Cost
	return [cardsToPick, indexesToRemove]
