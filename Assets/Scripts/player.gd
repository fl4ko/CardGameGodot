extends Node2D
class_name Player

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar

var userDeck : Deck
var max_health:int = 30
var current_health:int = 30
var current_mana: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = 30
	health_bar.value = 30

func _init() -> void:
	userDeck = Deck.new()
	current_mana = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
