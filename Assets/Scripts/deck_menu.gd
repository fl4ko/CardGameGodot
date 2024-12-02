extends MarginContainer

@onready var UserDeck = Deck.new()

@onready var image: Sprite2D = $Sprite2D
@onready var name_label: Label = $Label

func _ready() -> void:
	name_label.set_text("grzechu");
