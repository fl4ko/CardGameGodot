extends HBoxContainer
class_name Card

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

@onready var cards: userCardsResource = preload("res://Assets/Database/CardDatabase.tres")

@onready var border: TextureRect = $Image/Border
@onready var image: TextureRect = $Image
@onready var attack_label: Label = $Image/Border/AttackRect/AttackLabel
@onready var cost_label: Label = $Image/Border/CostRect/CostLabel
@onready var health_label: Label = $Image/Border/HealthRect/HealthLabel
@onready var name_label: Label = $Image/Border/NameRect/NameLabel

var cardName = "PoorInfantryman"

var tween_hover: Tween
var tween_handle: Tween
var tween_glide_back: Tween
var tween_staright_pickup: Tween

var original_z_index
var original_rotation
var original_scale = Vector2.ONE
var original_position = Vector2.ONE
var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2

# 0Name, 1Rarity, 2Type, 3Cost, 4HP, 5Attack, 6Image

@onready var borderImage

@export var Name: String
@export var Health: int
@export var Attack: int
@export var Cost: int


func _ready():
	cardName = cardName.replace(" ","")
	cardName = cardName.replace("-","")
	var cardInfo = cards.CardsStats.get(cardName)
	var cardImage = cardInfo[6]
	var cardType = cardInfo[2]
	
	print(cardImage)
	print(cardInfo)
	
	# Setting border image and size
	borderImage = Global.set_border_image(cardType)
	border.texture = load(borderImage)
	#border.scale *= size / border.texture.get_size()
	
	# Setting card image and size
	image.texture = load(cardImage)
	#image.scale *= size / image.texture.get_size()
	
	# Setting card name, attack, cost and hp
	attack_label.text = str(cardInfo[5])
	health_label.text = str(cardInfo[4])
	name_label.text = str(cardInfo[0])
	cost_label.text = str(cardInfo[3])
	
	original_scale = scale
	original_z_index = z_index

func _process(delta: float) -> void:
	follow_mouse(delta)

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale * Vector2(1.1, 1.2), 0.5)
	z_index = 21

func _on_mouse_exited() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.parallel().tween_property(self, "scale", original_scale, 0.55)
	z_index = original_z_index

func follow_mouse(delta: float) -> void:
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
	
	if event.is_pressed():
		original_position = position
		original_rotation = rotation
		following_mouse = true
	else:
		following_mouse = false
		if tween_glide_back and tween_glide_back.is_running():
			tween_glide_back.kill()
		tween_glide_back = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_glide_back.parallel().tween_property(self, "position", original_position, 0.3 + 0.075)
		tween_glide_back.parallel().tween_property(self, "rotation", original_rotation, 0.3 + 0.075)


func _on_gui_input(event: InputEvent) -> void:
	handle_mouse_click(event)
