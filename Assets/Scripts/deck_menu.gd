extends MarginContainer

const deck_model = preload("res://Assets/Models/deck.gd")

var UserDeck: Deck

@onready var name_label: Label = $Label

func _ready() -> void:
	name_label.set_text(UserDeck.deckName)
