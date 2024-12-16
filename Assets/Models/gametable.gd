extends Node
class_name GameTable

@onready var player: Player
@onready var enemy: Player

func _init() -> void:
	player = Player.new()
	enemy = Player.new()
	
