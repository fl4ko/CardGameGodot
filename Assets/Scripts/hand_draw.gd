extends TextureButton

@onready var cardSize = $'../../'.cardSize
@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")

var cardKey
var cardInfo

func _ready() -> void:
	scale *= cardSize/size

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var totalAmountOfCards = $'../../'.draw_card()
			
			if(totalAmountOfCards <= 0):
				disabled = true
