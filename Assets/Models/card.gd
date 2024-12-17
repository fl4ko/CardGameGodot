extends HBoxContainer
class_name CardScene

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

@onready var border: TextureRect = $Image/Border
@onready var image: TextureRect = $Image
@onready var attack_label: Label = $Image/Border/AttackRect/AttackLabel
@onready var cost_label: Label = $Image/Border/CostRect/CostLabel
@onready var health_label: Label = $Image/Border/HealthRect/HealthLabel
@onready var name_label: Label = $Image/Border/NameRect/NameLabel
@onready var kill_timer: Timer = $OnKillTimerByEnemy
#@onready var highlight: TextureRect = $Image/BorderHightlight

@onready var card_slots = $'../../CardSlots'
@onready var game_table_scene = $'../../..'

var tween_hover: Tween
var tween_handle: Tween
var tween_glide_back: Tween
var tween_staright_pickup: Tween
var tween_attack: Tween
var tween_destroy: Tween

var original_z_index
var original_rotation

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var original_scale = Vector2.ONE
var original_position = Vector2.ONE

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var last_pos: Vector2
var velocity: Vector2

var following_mouse: bool = false
var is_in_slot: bool = false
var is_player: bool = true
var is_hovered : bool = false
var slot_index: int
var deck_showcase: bool = false
# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image

@onready var borderImage
@onready var cardImage

var card: Card
var cardKey: String

func _ready():
	original_scale = scale
	original_z_index = z_index
	if(card != null):
		set_card_visuals()

func add_card(cardToAdd: Card) -> void:
	card = cardToAdd
	set_card_visuals()

func _process(delta: float) -> void:
	follow_mouse(delta)

func set_card_visuals() -> void:
	borderImage = Global.set_border_image(card.cardInfo[2])
	border.texture = load(borderImage)
	#border.scale *= size / border.texture.get_size()
	
	# Setting card image and size
	image.texture = load(card.cardInfo[6])
	#image.scale *= size / image.texture.get_size()
	
	# Setting card name, attack, cost and hp
	attack_label.text = str(card.Attack)
	health_label.text = str(card.Health)
	name_label.text = card.Name
	cost_label.text = str(card.Cost)

func _on_mouse_entered() -> void:
	if is_player and not deck_showcase and card.can_do_action:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.parallel().tween_property(self, "scale", original_scale * Vector2(1.1, 1.2), 0.5)
		z_index = 21

func _on_mouse_exited() -> void:
	if is_player and not is_hovered and not deck_showcase:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween_hover.parallel().tween_property(self, "scale", original_scale, 0.55)
		z_index = original_z_index

func follow_mouse(_delta: float) -> void:
	if deck_showcase: return
	if not following_mouse: return
	
	if tween_staright_pickup and tween_staright_pickup.is_running():
		tween_staright_pickup.kill()
		
	tween_staright_pickup = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_staright_pickup.parallel().tween_property(self, "rotation", 0, 0.3 + 0.075)
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos - Global.cardSize + Vector2(50, 50)

func handle_mouse_click(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed() and is_in_slot:
		if game_table_scene.currentCard == null and card.can_do_action:
			is_hovered = true
			_on_mouse_entered()
			game_table_scene.currentCard = self
		elif game_table_scene.currentCard == self and card.can_do_action:
			is_hovered = false
			_on_mouse_exited()
			game_table_scene.currentCard = null
		elif game_table_scene.currentCard != self and card.can_do_action:
			game_table_scene.currentCard.is_hovered = false
			game_table_scene.currentCard._on_mouse_exited()
			is_hovered = true
			_on_mouse_entered()
			game_table_scene.currentCard = self
		original_position = position
		original_rotation = rotation
	elif event.is_pressed():
		original_position = position
		original_rotation = rotation
		following_mouse = true
	else:
		following_mouse = false
		for i in range(card_slots.get_child_count()):
			var slot = card_slots.get_child(i, true)
			if Global.is_point_in_rectangle(get_global_mouse_position(), slot.get_position(), slot.get_size()):
				if slot.is_empty and not is_in_slot and card.Cost <= game_table_scene.game_table.player.current_mana:
					is_in_slot = true
					slot.is_empty = false
					slot_index = slot.get_index()
					position = slot.get_position() - Vector2(87.5, 130.5)
					game_table_scene.game_table.player.current_mana -= card.Cost
					game_table_scene.game_table.player.userDeck.currentHand.remove_at(card.inHandIndex)
					game_table_scene.update_indexes_player(card.inHandIndex)
					game_table_scene.game_table.player.userDeck.currentSlot[slot_index] = self
					game_table_scene.game_table.player.userDeck.cardsInSlot += 1
					var playerGUI = game_table_scene.playerNode.get_child(0,true)
					playerGUI.mana_count.text = "Cost:" + str(game_table_scene.game_table.player.current_mana)
					card.can_do_action = false
					if card.cardInfo[2] == "Fast":
						card.can_do_action = true
					return;
		if not is_in_slot:
			if tween_glide_back and tween_glide_back.is_running():
				tween_glide_back.kill()
			tween_glide_back = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_glide_back.parallel().tween_property(self, "position", original_position, 0.3 + 0.075)
			tween_glide_back.parallel().tween_property(self, "rotation", original_rotation, 0.3 + 0.075)
		if is_in_slot:
			if tween_glide_back and tween_glide_back.is_running():
				tween_glide_back.kill()
			tween_glide_back = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_glide_back.parallel().tween_property(self, "position", original_position, 0.5)

func pick_card_to_attack(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed() and is_in_slot and card.Health >= 0 and not check_if_bait_enemy():
		game_table_scene.currentCard.attack_card_animation(position)
		card.Health -= game_table_scene.currentCard.card.Attack
		health_label.text = str(card.Health)
		game_table_scene.currentCard.card.can_do_action = false
		game_table_scene.currentCard.is_hovered = false
		game_table_scene.currentCard._on_mouse_exited()
		game_table_scene.currentCard = null
		if(card.Health <= 0):
			$OnKillTimer.start()
	elif event.is_pressed() and is_in_slot and card.Health >= 0 and check_if_bait_enemy():
		if(card.cardInfo[2]) == "Bait":
			game_table_scene.currentCard.attack_card_animation(position)
			card.Health -= game_table_scene.currentCard.card.Attack
			health_label.text = str(card.Health)
			game_table_scene.currentCard.card.can_do_action = false
			game_table_scene.currentCard.is_hovered = false
			game_table_scene.currentCard._on_mouse_exited()
			game_table_scene.currentCard = null
			if(card.Health <= 0):
				$OnKillTimer.start()
	#elif event.is_pressed() and is_in_slot and card.Health >= 0 and check_if_bait_enemy()

func check_if_bait_enemy() -> bool:
	for card in game_table_scene.game_table.enemy.userDeck.currentSlot:
		if(card == null):
			continue
		if(card.slot_index == null):
			continue
		if(card.card.cardInfo[2] == "Bait"):
			return true
	return false
	
func check_if_bait_player() -> int:
	for card in game_table_scene.game_table.player.userDeck.currentSlot:
		if(card == null):
			continue
		if(card.slot_index == null):
			continue
		if(card.card.cardInfo[2] == "Bait"):
			return card.slot_index
	return -1

func _on_gui_input(event: InputEvent) -> void:
	if deck_showcase or game_table_scene.player_turn == false:
		return
	elif is_player:
		handle_mouse_click(event)
	elif not is_player and game_table_scene.currentCard != null:
		pick_card_to_attack(event)

func on_kill_timer() -> void:
	var slot = card_slots.get_child(slot_index,true)
	slot.is_empty = true
	game_table_scene.game_table.enemy.userDeck.currentSlot[slot_index] = null
	game_table_scene.game_table.enemy.userDeck.cardsInSlot -= 1
	game_table_scene.check_win_conditions()
	game_table_scene.enemy_cards.remove_child(self)
	queue_free()

func enemy_on_kill_timer() -> void:
	var slot = card_slots.get_child(slot_index,true)
	slot.is_empty = true
	game_table_scene.game_table.player.userDeck.currentSlot[slot_index] = null
	game_table_scene.game_table.player.userDeck.cardsInSlot -= 1
	game_table_scene.check_win_conditions()
	game_table_scene.player_cards.remove_child(self)
	queue_free()

func tween_hover_kill() -> void:
	tween_hover.kill()

func _on_mouse_exited_enemy_sim() -> void:
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale, 0.55)
	z_index = original_z_index
	if(tween_glide_back and tween_glide_back.is_running()):
		tween_glide_back.kill()
	if(tween_staright_pickup and tween_staright_pickup.is_running()):
		tween_staright_pickup.kill()
	$TweenHoverKill.start()

func _on_mouse_entered_enemy_sim() -> void:
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale * Vector2(1.1, 1.2), 0.5)
	z_index = 21
	$EnemyHoverTimer.start()

func enemy_move_card(slot) -> void: 
	_on_mouse_entered_enemy_sim()
	
	image.texture = load(card.cardInfo[6])
	border.show()
	name_label.show()
	attack_label.show()
	cost_label.show()
	health_label.show()
	
	tween_staright_pickup = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_staright_pickup.parallel().tween_property(self, "rotation", 0, 0.3 + 0.075)
	
	is_in_slot = true
	slot.is_empty = false
	card.can_do_action = false
	if card.cardInfo[2] == "Fast":
		card.can_do_action = true
	slot_index = slot.get_index()
	
	tween_glide_back = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_glide_back.parallel().tween_property(self, "position", slot.get_position() - Vector2(87.5, 130.5), 0.3 + 0.075)

func enemy_card_attack() -> void:
	if(card.can_do_action == false):
		return
	var bait_index = check_if_bait_player()
	_on_mouse_entered_enemy_sim()
	if(bait_index == -1):
		for cardToAttack in game_table_scene.game_table.player.userDeck.currentSlot:
			if(cardToAttack == null):
				continue
			if(cardToAttack.card.Health <= card.Attack):
				attack_card_animation(cardToAttack.position)
				cardToAttack.card.Health -= card.Attack
				cardToAttack.health_label.text = str(cardToAttack.card.Health)
				card.can_do_action = false
				if(cardToAttack.card.Health <= 0):
					cardToAttack.kill_timer.start()
				_on_mouse_exited_enemy_sim()
				return
		var highestATKCard
		for cardToAttack in game_table_scene.game_table.player.userDeck.currentSlot:
			if(cardToAttack == null):
				continue
			if(highestATKCard == null || highestATKCard.card.Attack <= cardToAttack.card.Attack):
				highestATKCard = cardToAttack
		if highestATKCard == null:
			return
		attack_card_animation(highestATKCard.position)
		highestATKCard.card.Health -= card.Attack
		highestATKCard.health_label.text = str(highestATKCard.card.Health)
		card.can_do_action = false
		if(highestATKCard.card.Health <= 0):
			highestATKCard.kill_timer.start()
		_on_mouse_exited_enemy_sim()
		return
	elif(bait_index != -1):
		var cardToAttack = game_table_scene.game_table.player.userDeck.currentSlot[bait_index]
		attack_card_animation(cardToAttack.position)
		cardToAttack.card.Health -= card.Attack
		cardToAttack.health_label.text = str(cardToAttack.card.Health)
		card.can_do_action = false
		if(cardToAttack.card.Health <= 0):
			cardToAttack.kill_timer.start()
		_on_mouse_exited_enemy_sim()
		return

func attack_card_animation(to_pos: Vector2) -> void:
	if tween_attack and tween_attack.is_running():
		tween_attack.kill()
	tween_attack = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	var original_pos = position
	var original_index = z_index
	z_index = 100
	tween_attack.tween_property(self, "position", to_pos - Vector2(0, 50), 0.375)
	tween_attack.tween_property(self, "position", original_pos, 0.375)
	z_index = original_index

	
