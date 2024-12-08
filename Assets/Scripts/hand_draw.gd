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
			if isFirstDraw:
				$'../../'.draw_card(get_total_amount_of_cards(), position)
		if(totalAmountOfCards <= 0):
			disabled = true
			
func get_total_amount_of_cards():
	var totalCardsCount = 0
	for key in userDeckResource.CardsStats.keys():
		var card = userDeckResource.CardsStats[key]
		totalCardsCount += card[8]
	print(totalCardsCount)
	return totalCardsCount
