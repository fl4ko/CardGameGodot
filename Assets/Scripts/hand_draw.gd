extends TextureButton

@onready var cardSize = $'../../'.cardSize
@onready var player : Player = Player.new()
@onready var enemy : Player = Player.new()
var cardKey
var cardInfo

func _ready() -> void:
	scale *= cardSize/size
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				$'../../'.draw_card_enemy(enemy.userDeck.currentNrOfCards, position)
				$'../../'.draw_card_player(player.userDeck.currentNrOfCards, position)
				self.hide()
