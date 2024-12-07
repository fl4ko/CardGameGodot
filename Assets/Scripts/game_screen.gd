extends Node2D

const cardSize = Vector2(150, 225)

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")
@onready var cardBase = preload("res://Assets/Scenes/card_base.tscn")

@onready var viewportSize = Vector2(get_viewport().size)
@onready var centerCardOval = viewportSize * Vector2(0.5, 1.2)
@onready var horizontalRadius = viewportSize.x * 0.45
@onready var verticalRadius = viewportSize.y * 0.58

var ovalAngle = Vector2()
var angle = deg_to_rad(90) - 0.6
var currentCards

func _ready() -> void:
	print(userDeckResource.CardsStats.keys())
	currentCards = userDeckResource.CardsStats.duplicate(true)

func draw_card():
	var newCardBase = cardBase.instantiate()
	var card = select_random_card()
	print(card)
	
	newCardBase.cardName = card[0]
	ovalAngle = Vector2(horizontalRadius * cos(angle), -verticalRadius * sin(angle))
	newCardBase.position = centerCardOval + ovalAngle - newCardBase.size/2
	newCardBase.scale *= cardSize/newCardBase.size
	$Cards.add_child(newCardBase)
	
	angle += 0.2
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
