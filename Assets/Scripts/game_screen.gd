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
@onready var game_result: MarginContainer = $GameResult

@onready var screen_size = Vector2(get_viewport().size)

var valid_cards_player: Array
var valid_cards_enemy: Array

@onready var background: Sprite2D = $Background
@onready var player_slots = $Player/CardSlots
@onready var enemy_slots = $Enemy/CardSlots

@onready var playerNode = $Player/PlayerNode
@onready var enemyNode = $Enemy/EnemyNode

@onready var player_cards = $Player/Cards
@onready var enemy_cards = $Enemy/Cards

@onready var currentCard : CardScene
var player_turn: bool
var is_game_started: bool = false

var sine_offset_mult: float = 0.0
@onready var tweenPlayer: Tween
@onready var tweenEnemy: Tween

func _ready() -> void:
	game_table = GameTable.new()
	rot_max = deg_to_rad(rot_max)
	place_card_slots(true, 5)
	place_card_slots(false, 5)
	place_players()
	player_turn = true
	$TurnButton.hide()
	game_result.hide()
	#game_result.position = background.position

func end_turn() -> void:
	player_turn = false
	$TurnButton.hide()
	enemy_turn()
	await get_tree().create_timer(min(3 * max(game_table.enemy.userDeck.cardsInSlot,1),12)).timeout
	if(game_table.player.base_mana < 7):
		game_table.player.base_mana += 1
		game_table.enemy.base_mana += 1
	game_table.player.current_mana = game_table.player.base_mana
	game_table.enemy.current_mana = game_table.enemy.base_mana
	var playerGUI = playerNode.get_child(0,true)
	playerGUI.mana_count.text = "Cost:" + str(game_table.player.current_mana)
	playerGUI = enemyNode.get_child(0,true)
	playerGUI.mana_count.text = "Cost:" + str(game_table.enemy.current_mana)
	for card in game_table.player.userDeck.currentSlot:
		if(card == null):
			continue
		card.card.can_do_action = true
	for card in game_table.enemy.userDeck.currentSlot:
		if(card == null):
			continue
		card.card.can_do_action = true
	player_turn = true
	$TurnButton.show()

func draw_card_player(amountToDraw: int, fromPos: Vector2):
	if tweenPlayer and tweenPlayer.is_running():
		tweenPlayer.kill()
	tweenPlayer = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = game_table.player.userDeck.currentHand[i]
		var new_card_base = card_base.instantiate()
		new_card_base.global_position = fromPos
		new_card_base.scale *= cardSize/new_card_base.size
		
		var final_pos: Vector2 = -(new_card_base.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
		final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
		var rot_radians: float
		
		final_pos.y += 220
		rot_radians = lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
		new_card_base.card = card
		player_cards.add_child(new_card_base)
		tweenPlayer.parallel().tween_property(new_card_base, "position", final_pos, 0.3 + (i * 0.075))
		tweenPlayer.parallel().tween_property(new_card_base, "rotation", rot_radians, 0.3 + (i * 0.075))
	tweenPlayer.tween_callback(set_process.bind(true))
	tweenPlayer.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)
	$TurnButton.show()

func draw_card_enemy(amountToDraw: int, fromPos: Vector2):
	if tweenEnemy and tweenEnemy.is_running():
		tweenEnemy.kill()
	tweenEnemy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amountToDraw):
		var card = game_table.enemy.userDeck.currentHand[i]
		var new_card_base = card_base.instantiate()
		new_card_base.global_position = fromPos
		new_card_base.scale *= cardSize/new_card_base.size
		
		var final_pos: Vector2 = -(new_card_base.size / 2.0) - Vector2(card_offset_x * (amountToDraw - 1 - i), -550)
		final_pos.x += ((card_offset_x * (amountToDraw-1)) / 2.0) + 550
		var rot_radians: float
		
		final_pos.y -= 440
		rot_radians = -lerp_angle(-rot_max, rot_max, float(i)/float(amountToDraw-1))
		new_card_base.card = card
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
	enemy_instance.current_health = game_table.enemy.current_health
	enemyNode.add_child(enemy_instance)
	var player_instance = playerScene.instantiate()
	player_instance.position = Vector2(1043,648)
	player_instance.current_health = game_table.player.current_health
	playerNode.add_child(player_instance)

func place_card_slots(is_player: bool, slots_amount) -> void:
	var spacing = cardSize.x * slot_spacing_ratio
	var total_width = (slots_amount * cardSize.x) + ((slots_amount - 1) * spacing)
	var start_x = (screen_size.x - total_width) / 2

	for i in range(slots_amount):
		var new_card_slot = card_slot.instantiate()
		if is_player:
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 450)
			player_slots.add_child(new_card_slot)
		else:
			new_card_slot.position = Vector2(start_x + i * (cardSize.x + spacing), 255)
			enemy_slots.add_child(new_card_slot)
			new_card_slot.is_player = false

func update_indexes(index: int) -> void:
	for card in enemy_cards.get_children():
		if(card.card.inHandIndex >= index):
			card.card.inHandIndex -= 1
			
func update_indexes_player(index: int) -> void:
	for card in player_cards.get_children():
		if(card.card.inHandIndex >= index):
			card.card.inHandIndex -= 1 

func check_win_conditions() -> void:
	if(game_table.enemy.current_health <= 0):
		game_result.game_won = true
		game_result.display_game_result()
		game_result.show()
	elif (game_table.enemy.userDeck.currentHand.size() <= 0 and game_table.enemy.userDeck.is_null()):
		game_result.game_won = true
		game_result.display_game_result()
		game_result.show()
	if(game_table.player.current_health <= 0):
		game_result.game_won = false
		game_result.display_game_result()
		game_result.show()
	elif(game_table.player.userDeck.currentHand.size() <= 0 and game_table.player.userDeck.is_null()):
		game_result.game_won = false
		game_result.display_game_result()
		game_result.show()
		
func enemy_add_card_to_table(arrayOfCards) -> void:
	var foundCard = false
	for card in arrayOfCards[0]:
		for cardScene in enemy_cards.get_children():
			if cardScene.card == card and game_table.enemy.current_mana >= cardScene.card.Cost:
				for slot in enemy_slots.get_children():
					if slot.is_empty:
						slot.is_empty = false
						foundCard = true
						cardScene.enemy_move_card(slot)
						game_table.enemy.userDeck.currentHand.remove_at(arrayOfCards[1][0])
						game_table.enemy.userDeck.currentSlot[slot.get_index()] = cardScene
						game_table.enemy.userDeck.cardsInSlot += 1
						game_table.enemy.current_mana -= cardScene.card.Cost
						var playerGUI = enemyNode.get_child(0,true)
						playerGUI.mana_count.text = "Cost:" + str(game_table.enemy.current_mana)
						update_indexes(arrayOfCards[1][0])
						arrayOfCards[1].pop_front()
						await get_tree().create_timer(1).timeout
						break
			if foundCard == true:
				foundCard = false
				break

func enemy_turn() -> void:
	var card = game_table.get_best_card()
	var all_full = true
	for slot in game_table.enemy.userDeck.currentSlot:
		if slot == null:
			all_full = false
	if(not card.is_empty() and not all_full):
		enemy_add_card_to_table(card)
	await get_tree().create_timer(2).timeout
	enemy_attack()

func enemy_attack() -> void:
	if game_table.player.userDeck.is_null():
		return
	for card in game_table.enemy.userDeck.currentSlot:
		if card == null:
			continue
		if card.card.can_do_action == true:
			card.enemy_card_attack()
			if game_table.player.userDeck.is_null():
				return
			await get_tree().create_timer(2).timeout

func show_win_debug():
	game_result.game_won = false
	game_result.display_game_result()
	game_result.show()
	
