extends Node

signal player_health_changed(new_health, max_health)
signal player_leveled_up(new_level)
signal wave_completed(wave_num)
signal experience_gained(amount, total_xp, xp_to_next_level)
signal robe_equipped(robe_data)
signal hat_equipped(hat_data)

var current_score: int = 0
var enemies_defeated: int = 0
var run_start_time: float = 0.0

func _ready():
	print("GameManager initialized")

func start_run():
	current_score = 0
	enemies_defeated = 0
	run_start_time = Time.get_ticks_msec() / 1000.0

func add_score(amount: int):
	current_score += amount

func enemy_defeated():
	enemies_defeated += 1

func end_run():
	var duration = (Time.get_ticks_msec() / 1000.0) - run_start_time
	# Candy = enemies killed / 2 + 1 candy per 10 seconds survived
	var candy_earned = int(enemies_defeated / 2.0) + int(duration / 10.0)
	SaveManager.add_candy(candy_earned)
	print("Run ended. Earned ", candy_earned, " candies!")
	return candy_earned
