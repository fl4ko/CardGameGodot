extends HBoxContainer
class_name CardScene

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

@onready var game_screen: PackedScene = preload("res://Assets/Scenes/game_screen.tscn")

@onready var border: TextureRect = $Image/Border
@onready var image: TextureRect = $Image
@onready var attack_label: Label = $Image/Border/AttackRect/AttackLabel
@onready var cost_label: Label = $Image/Border/CostRect/CostLabel
@onready var health_label: Label = $Image/Border/HealthRect/HealthLabel
@onready var name_label: Label = $Image/Border/NameRect/NameLabel
#@onready var highlight: TextureRect = $Image/BorderHightlight

@onready var card_slots = $'../../CardSlots'

var tween_hover: Tween
var tween_handle: Tween
var tween_glide_back: Tween
var tween_staright_pickup: Tween

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
var inHandIndex: int
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

func _process(delta: float) -> void:
	follow_mouse(delta)

func add_card(cardToAdd: Card) -> void:
	card = cardToAdd
	set_card_visuals()

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
	if is_player and not deck_showcase:
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
		if $'../../..'.currentCard == null:
			is_hovered = true
			_on_mouse_entered()
			$'../../..'.currentCard = self
		elif $'../../..'.currentCard == self:
			is_hovered = false
			_on_mouse_exited()
			$'../../..'.currentCard = null
		elif $'../../..'.currentCard != self:
			$'../../..'.currentCard.is_hovered = false
			$'../../..'.currentCard._on_mouse_exited()
			is_hovered = true
			_on_mouse_entered()
			$'../../..'.currentCard = self
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
				if slot.is_empty and not is_in_slot:
					is_in_slot = true
					slot.is_empty = false
					slot_index = slot.get_index()
					position = slot.get_position() - Vector2(87.5, 130.5)
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

func pick_enemy_card_to_attack(event: InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed() and is_in_slot and card.Health > 0:
		_on_mouse_entered_enemy_sim()
		card.Health -= $'../../..'.currentCard.card.Attack
		health_label.text = str(card.Health)
		print($'../../..'.game_table.enemy.userDeck.currentHand[0])
		if(card.Health <= 0):
			$OnKillTimer.start()

func _on_gui_input(event: InputEvent) -> void:
	if deck_showcase:
		return
	elif is_player:
		handle_mouse_click(event)
	elif not is_player and $'../../..'.currentCard != null:
		pick_enemy_card_to_attack(event)

func on_kill_timer() -> void:
	var slot = card_slots.get_child(slot_index,true)
	slot.is_empty = true
	$'../../..'.game_table.enemy.userDeck.currentHand.remove_at(inHandIndex)
	$'../../..'.update_indexes(inHandIndex)
	$'../../..'.check_win_conditions()
	$'../../..'.enemy_cards.remove_child(self)
	queue_free()

func tween_hover_kill() -> void:
	tween_hover.kill()

func _on_mouse_exited_enemy_sim() -> void:
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale, 0.55)
	z_index = original_z_index
	tween_glide_back.kill()
	tween_staright_pickup.kill()
	$TweenHoverKill.start()

func _on_mouse_entered_enemy_sim() -> void:
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale * Vector2(1.1, 1.2), 0.5)
	z_index = 21
	$EnemyHoverTimer.start()

func enemy_move_card(slot_index_enemy: int) -> void: 
	_on_mouse_entered_enemy_sim()
	
	image.texture = load(card.cardInfo[6])
	border.show()
	name_label.show()
	attack_label.show()
	cost_label.show()
	health_label.show()
	
	tween_staright_pickup = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_staright_pickup.parallel().tween_property(self, "rotation", 0, 0.3 + 0.075)
	
	var slot = card_slots.get_child(slot_index_enemy,true)
	is_in_slot = true
	slot.is_empty = false
	slot_index = slot.get_index()
	tween_glide_back = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_glide_back.parallel().tween_property(self, "position", slot.get_position() - Vector2(87.5, 130.5), 0.3 + 0.075)
