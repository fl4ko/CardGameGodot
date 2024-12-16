extends Node2D
class_name Player

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var mana_count: Label = $VBoxContainer/ManaAmount

var userDeck : Deck
var max_health:int = 30
var current_health:int = 30
var current_mana: int = 0
var base_mana: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = 30
	health_bar.value = 30
	mana_count.text = "Cost:" + str(current_mana)

func _init() -> void:
	userDeck = Deck.new()
	current_mana = base_mana

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
