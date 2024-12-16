extends Node
class_name Card

var cards: userCardsResource

@export var Name: String
@export var Health: int
@export var Attack: int
@export var Cost: int
@export var cardInfo: Array
@export var hasAttacked: bool

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image

func _init(cardInfoToAdd: Array) -> void:
	cardInfo = cardInfoToAdd
	Name = cardInfo[0]
	Health = cardInfo[4]
	Cost = cardInfo[3]
	Attack = cardInfo[5]
	hasAttacked = false
