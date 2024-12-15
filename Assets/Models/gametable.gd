extends Node
class_name GameTable

@onready var player: Player
@onready var enemy: Player

@onready var player_card_slots: Array
@onready var enemy_card_slots: Array

func _init() -> void:
	player = Player.new()
	enemy = Player.new()
