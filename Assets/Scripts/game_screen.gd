extends Node2D

const cardSize = Vector2(125, 187.50)

@export var card_offset_x: float = 50.0
@export var rot_max: float = 10.0
@export var anim_offset_y: float = 0.3

@onready var userDeckResource : userCardsResource = preload("res://Assets/Database/User/UserCardRes.tres")
@onready var cardBase = preload("res://Assets/Scenes/card_base.tscn")

@onready var screen_size = Vector2(get_viewport().size)

var currentCards
var spacing = cardSize.x * 1.1
var start_x = cardSize.x / 2

var sine_offset_mult: float = 0.0
@onready var tween: Tween

func _ready() -> void:
	print(userDeckResource.CardsStats.keys())
	currentCards = userDeckResource.CardsStats.duplicate(true)
	rot_max = deg_to_rad(rot_max)

#func draw_card(amountToDraw: int):
	#for i in range(0, amountToDraw):
		#var amountOfChildren = $Cards.get_child_count()
		#if amountOfChildren < 12:
			#var card = select_random_card()
			#print(card)
			#if card.size() > 0:
				#var newCardBase = cardBase.instantiate()
				#if amountOfChildren < 6:
					#var position_x = start_x + amountOfChildren * spacing
					#var position_y = screen_size.y - cardSize.y - 135
					#newCardBase.position = Vector2(position_x, position_y)
				#else:
					#var position_x = start_x + (amountOfChildren-6) * spacing
					#var position_y = screen_size.y - cardSize.y - 200
					#newCardBase.position = Vector2(position_x, position_y)
				#newCardBase.cardName = card[0]
				#newCardBase.scale *= cardSize/newCardBase.size
				#$Cards.add_child(newCardBase)
				#card[8] -= 1
	#return get_total_amount_of_cards()
	
func draw_card(amountToDraw: int, fromPos: Vector2):
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var newCardBase = cardBase.instantiate()
		var card = select_random_card()
		newCardBase.global_position = fromPos
		newCardBase.scale *= cardSize/newCardBase.size
		
		var final_pos: Vector2 = -(newCardBase.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
		final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550

		var rot_radians: float = lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
		
		tween.parallel().tween_property(newCardBase, "position", final_pos, 0.3 + (i * 0.075))
		tween.parallel().tween_property(newCardBase, "rotation", rot_radians, 0.3 + (i * 0.075))
		
		newCardBase.cardName = card[0]
		$Cards.add_child(newCardBase)
		
	tween.tween_callback(set_process.bind(true))
	tween.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)
	
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
