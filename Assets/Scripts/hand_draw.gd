extends TextureButton

@onready var cardSize = $'../../'.cardSize
@onready var userDeck : Deck = Deck.new()
var cardKey
var cardInfo
var isFirstDraw = true;
var totalAmountOfCards = 0

func _ready() -> void:
	scale *= cardSize/size

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				$'../../'.draw_card(userDeck.currentNrOfCards, position, true)
