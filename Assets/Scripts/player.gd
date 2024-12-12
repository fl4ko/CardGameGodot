extends Node2D

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar

var userDeck : Deck
var max_health:int = 30
var current_health:int = 30
var current_mana: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	userDeck = Deck.new()
	health_bar.max_value = 30
	health_bar.value = 30
	current_mana = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
