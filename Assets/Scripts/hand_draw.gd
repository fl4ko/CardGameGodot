extends TextureButton

@onready var cardSize = $'../../'.cardSize
@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")
var cardKey
var cardInfo
var isFirstDraw = true;
var totalAmountOfCards = 0

func _ready() -> void:
	scale *= cardSize/size

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				if not disabled:
					$'../../'.draw_card(Global.get_total_amount_of_cards(), position)
					disabled = true
