extends Node2D

const cardSize = Vector2(125, 187.50)

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")
@onready var cardBase = preload("res://Assets/Scenes/card_base.tscn")

@onready var screen_size = Vector2(get_viewport().size)

var currentCards

func _ready() -> void:
	print(userDeckResource.CardsStats.keys())
	currentCards = userDeckResource.CardsStats.duplicate(true)

func draw_card():
	var amountOfChildren = $Cards.get_child_count()
	if amountOfChildren < 7:
		var newCardBase = cardBase.instantiate()
		var card = select_random_card()
		
		if card.size() > 0:
			print(card)
			var spacing = cardSize.x * 1.1  # Adjust spacing between cards
			var start_x = cardSize.x / 2  # Start from the left side with some margin
			var position_x = start_x + amountOfChildren * spacing
			var position_y = screen_size.y - cardSize.y - 50  # Adjust 50 for bottom margin
			
			newCardBase.cardName = card[0]
			newCardBase.position = Vector2(position_x, position_y)
			newCardBase.scale *= cardSize/newCardBase.size
			$Cards.add_child(newCardBase)
			card[8] -= 1
	return get_total_amount_of_cards()

func select_random_card() -> Array:
	if currentCards.size() <= 0:
		return []
	
	var validCards = []
	for key in currentCards.keys():
		var card = currentCards[key]
		var amountInDeck = card[8]
		if amountInDeck > 0:
			validCards.append(key)
	
	if validCards.size() <= 0:
		return []
		
	randomize()
	return currentCards[validCards[randi() % validCards.size()]]

func get_total_amount_of_cards():
	var totalCardsCount = 0
	for key in currentCards:
		var card = currentCards[key]
		totalCardsCount += card[8]
	print(totalCardsCount)
	return totalCardsCount
