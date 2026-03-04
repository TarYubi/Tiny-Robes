extends Node

signal player_health_changed(new_health, max_health)
signal player_leveled_up(new_level)
signal experience_gained(amount, total_xp, xp_to_next_level)
signal robe_equipped(robe_data)
signal hat_equipped(hat_data)

var current_score: int = 0
var enemies_defeated: int = 0

func _ready():
	print("GameManager initialized")

func add_score(amount: int):
	current_score += amount

func enemy_defeated():
	enemies_defeated += 1
