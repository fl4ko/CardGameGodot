extends Node2D

const cardSize = Vector2(125, 187.50)
const slot_spacing_ratio: float = 0.2

@export var card_offset_x: float = 50.0
@export var rot_max: float = 10.0
@export var anim_offset_y: float = 0.3

@onready var game_table : GameTable

@onready var playerScene = preload("res://Assets/Scenes/player.tscn")
@onready var enemyScene = preload("res://Assets/Scenes/enemy.tscn")

@onready var card_base = preload("res://Assets/Scenes/card_base.tscn")
@onready var card_slot = preload("res://Assets/Scenes/card_slot.tscn")

@onready var screen_size = Vector2(get_viewport().size)

var valid_cards_player: Array
var valid_cards_enemy: Array

@onready var player_slots = $Player/CardSlots
@onready var enemy_slots = $Enemy/CardSlots

@onready var playerNode = $Player/PlayerNode
@onready var enemyNode = $Enemy/EnemyNode

@onready var player_cards = $Player/Cards
@onready var enemy_cards = $Enemy/Cards

@onready var currentCard : Card
@onready var currentAttackedCard : Card

var sine_offset_mult: float = 0.0
@onready var tweenPlayer: Tween
@onready var tweenEnemy: Tween

func _ready() -> void:
	game_table = GameTable.new()
	rot_max = deg_to_rad(rot_max)
	place_card_slots(true, 5)
	place_card_slots(false, 5)
	place_players()

func draw_card_player(amountToDraw: int, fromPos: Vector2):
	if tweenPlayer and tweenPlayer.is_running():
		tweenPlayer.kill()
	tweenPlayer = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = game_table.player.userDeck.userDeckResource.CardsStats[valid_cards_player[i]]
		if card.size() > 0:
			var new_card_base = card_base.instantiate()
			new_card_base.global_position = fromPos
			new_card_base.scale *= cardSize/new_card_base.size
			
			var final_pos: Vector2 = -(new_card_base.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
			final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
			var rot_radians: float
			
			final_pos.y += 220
			rot_radians = lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
			new_card_base.cardName = card[0]
			player_cards.add_child(new_card_base)
			tweenPlayer.parallel().tween_property(new_card_base, "position", final_pos, 0.3 + (i * 0.075))
			tweenPlayer.parallel().tween_property(new_card_base, "rotation", rot_radians, 0.3 + (i * 0.075))
	tweenPlayer.tween_callback(set_process.bind(true))
	tweenPlayer.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)

func draw_card_enemy(amountToDraw: int, fromPos: Vector2):
	if tweenEnemy and tweenEnemy.is_running():
		tweenEnemy.kill()
	tweenEnemy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = game_table.enemy.userDeck.userDeckResource.CardsStats[valid_cards_enemy[i]]
		if card.size() > 0:
			var new_card_base = card_base.instantiate()
			new_card_base.global_position = fromPos
			new_card_base.scale *= cardSize/new_card_base.size
			
			var final_pos: Vector2 = -(new_card_base.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
			final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
			var rot_radians: float
			
			final_pos.y -= 440
			rot_radians = -lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
			new_card_base.cardName = card[0]
			enemy_cards.add_child(new_card_base)
			new_card_base.image.texture = load("res://Assets/CardAssets/cardBack.jpg")
			new_card_base.border.hide()
			new_card_base.is_player = false
			tweenEnemy.parallel().tween_property(new_card_base, "position", final_pos, 0.3 + (i * 0.075))
			tweenEnemy.parallel().tween_property(new_card_base, "rotation", rot_radians, 0.3 + (i * 0.075))
	tweenEnemy.tween_callback(set_process.bind(true))
	tweenEnemy.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)

func place_players() -> void:
	var enemy_instance = enemyScene.instantiate()
	enemy_instance.position = Vector2(10,116)
	enemyNode.add_child(enemy_instance)
	var player_instance = playerScene.instantiate()
	player_instance.position = Vector2(1043,648)
	playerNode.add_child(player_instance)

func place_card_slots(is_player: bool, slots_amount) -> void:
	var spacing = cardSize.x * slot_spacing_ratio
	var total_width = (slots_amount * cardSize.x) + ((slots_amount - 1) * spacing)
	var start_x = (screen_size.x - total_width) / 2

	for i in range(slots_amount):
		
		if is_player:
			var new_card_slot = card_slot.instantiate()
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 450)
			player_slots.add_child(new_card_slot)
		else:
			var new_card_slot = card_slot.instantiate()
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 255)
			enemy_slots.add_child(new_card_slot)
			new_card_slot.is_player = false

func add_enemy_card_test():
	var card = enemy_cards.get_child(3,true)
	card.enemy_move_card(4)
	
"""
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
"""
