extends Resource
class_name UserData

@export var candy_count: int = 0
@export var purchased_upgrades: Dictionary = {
	"health_bonus": 0,
	"speed_bonus": 0,
	"lucky_start": 0,
	"candy_magnet": 0,
	"extra_life": 0,
	"rarity_boost": 0
}
@export var unlocked_robes: Array[String] = [] # None at start
@export var unlocked_hats: Array[String] = []
