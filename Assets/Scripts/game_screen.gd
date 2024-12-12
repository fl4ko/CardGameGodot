extends Node2D

const cardSize = Vector2(125, 187.50)
const slot_spacing_ratio: float = 0.2

@export var card_offset_x: float = 50.0
@export var rot_max: float = 10.0
@export var anim_offset_y: float = 0.3

@onready var userDeck : Deck = Deck.new()
@onready var enemyDeck : Deck = Deck.new()
@onready var card_base = preload("res://Assets/Scenes/card_base.tscn")
@onready var card_slot = preload("res://Assets/Scenes/card_slot.tscn")

@onready var screen_size = Vector2(get_viewport().size)

var current_cards
var enemy_cards
var spacing = cardSize.x * 1.1
var start_x = cardSize.x / 2

var valid_cards: Array

var sine_offset_mult: float = 0.0
@onready var tweenPlayer: Tween
@onready var tweenEnemy: Tween

func _ready() -> void:
	print(userDeck.userDeckResource.CardsStats.keys())
	current_cards = userDeck.userDeckResource.CardsStats.duplicate(true)
	enemy_cards = enemyDeck.userDeckResource.CardsStats.duplicate(true)
	rot_max = deg_to_rad(rot_max)
	#var new_card_slot = card_slot.instantiate()
	#$Player/CardSlots.add_child(new_card_slot)
	place_card_slots(true, 5)
	place_card_slots(false, 5)
	
	if not current_cards.size() <= 0:
		for key in current_cards.keys():
			var card = current_cards[key]
			var amountInDeck = card[8]
			if amountInDeck > 0:
				for i in range(amountInDeck):
					valid_cards.append(key)

func draw_card(amountToDraw: int, fromPos: Vector2, is_player: bool):
	if(is_player):
		if tweenPlayer and tweenPlayer.is_running():
			tweenPlayer.kill()
		tweenPlayer = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		if tweenEnemy and tweenEnemy.is_running():
			tweenEnemy.kill()
		tweenEnemy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = current_cards[valid_cards[i]]
		if card.size() > 0:
			var new_card_base = card_base.instantiate()
			new_card_base.global_position = fromPos
			new_card_base.scale *= cardSize/new_card_base.size
			
			var final_pos: Vector2 = -(new_card_base.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
			final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
			var rot_radians: float
			if(!is_player):
				final_pos.y -= 440
				rot_radians = -lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
				new_card_base.cardName = card[0]
				$Enemy/Cards.add_child(new_card_base)
				new_card_base.image.texture = load("res://Assets/CardAssets/cardBack.jpg")
				new_card_base.border.hide()
				new_card_base.is_player = false
				tweenEnemy.parallel().tween_property(new_card_base, "position", final_pos, 0.3 + (i * 0.075))
				tweenEnemy.parallel().tween_property(new_card_base, "rotation", rot_radians, 0.3 + (i * 0.075))
			else:
				final_pos.y += 220
				rot_radians = lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
				new_card_base.cardName = card[0]
				$Player/Cards.add_child(new_card_base)
				tweenPlayer.parallel().tween_property(new_card_base, "position", final_pos, 0.3 + (i * 0.075))
				tweenPlayer.parallel().tween_property(new_card_base, "rotation", rot_radians, 0.3 + (i * 0.075))
	if(!is_player):	
		tweenEnemy.tween_callback(set_process.bind(true))
		tweenEnemy.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)
	else:	
		tweenPlayer.tween_callback(set_process.bind(true))
		tweenPlayer.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)

func place_card_slots(is_player: bool, slots_amount) -> void:
	var spacing = cardSize.x * slot_spacing_ratio
	var total_width = (slots_amount * cardSize.x) + ((slots_amount - 1) * spacing)
	var start_x = (screen_size.x - total_width) / 2

	for i in range(slots_amount):
		var new_card_slot = card_slot.instantiate()
		
		if is_player:
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 450)
			$Player/CardSlots.add_child(new_card_slot)
		else:
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 225)
			$Enemy/CardSlots.add_child(new_card_slot)
			new_card_slot.is_player = false

func select_random_card() -> Array:
	# TO MA BYC COS INNEGO
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
