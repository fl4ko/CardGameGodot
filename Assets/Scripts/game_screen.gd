extends Node2D

const cardSize = Vector2(125, 187.50)

@export var card_offset_x: float = 50.0
@export var rot_max: float = 10.0
@export var anim_offset_y: float = 0.3

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")
@onready var cardBase = preload("res://Assets/Scenes/card_base.tscn")

@onready var screen_size = Vector2(get_viewport().size)

var current_cards
var enemy_cards
var spacing = cardSize.x * 1.1
var start_x = cardSize.x / 2

var sine_offset_mult: float = 0.0
@onready var tween: Tween

func _ready() -> void:
	print(userDeckResource.CardsStats.keys())
	current_cards = userDeckResource.CardsStats.duplicate(true)
	enemy_cards = userDeckResource.CardsStats.duplicate(true)
	rot_max = deg_to_rad(rot_max)

	
func draw_card(amountToDraw: int, fromPos: Vector2):
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = select_random_card()
		if card.size() > 0:
			var newCardBase = cardBase.instantiate()
			newCardBase.global_position = fromPos
			newCardBase.scale *= cardSize/newCardBase.size
			
			var final_pos: Vector2 = -(newCardBase.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
			final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
			final_pos.y += 220

			var rot_radians: float = lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
			
			tween.parallel().tween_property(newCardBase, "position", final_pos, 0.3 + (i * 0.075))
			tween.parallel().tween_property(newCardBase, "rotation", rot_radians, 0.3 + (i * 0.075))
			
			newCardBase.cardName = card[0]
			$Player/Cards.add_child(newCardBase)
			card[8] -= 1
		
	tween.tween_callback(set_process.bind(true))
	tween.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)
	
func select_random_card() -> Array:
	if current_cards.size() <= 0:
		return []
	
	var validCards = []
	for key in current_cards.keys():
		var card = current_cards[key]
		var amountInDeck = card[8]
		if amountInDeck > 0:
			validCards.append(key)
	
	if validCards.size() <= 0:
		return []
		
	randomize()
	return current_cards[validCards[randi() % validCards.size()]]
