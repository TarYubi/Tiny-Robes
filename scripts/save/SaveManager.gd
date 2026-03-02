extends Node

const SAVE_PATH = "user://user_data.tres"

var user_data: UserData

func _ready():
	load_game()

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		user_data = ResourceLoader.load(SAVE_PATH)
		if not user_data:
			user_data = UserData.new()
	else:
		user_data = UserData.new()
		save_game()

func save_game():
	ResourceSaver.save(user_data, SAVE_PATH)

func add_candy(amount: int):
	user_data.candy_count += amount
	save_game()

func spend_candy(amount: int) -> bool:
	if user_data.candy_count >= amount:
		user_data.candy_count -= amount
		save_game()
		return true
	return false
