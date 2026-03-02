extends EnemyBase

@export var is_mini: bool = false

func _ready():
	super._ready()
	if is_mini:
		scale = Vector2(0.5, 0.5)
		health = 10.0
		speed *= 1.5

func die():
	if not is_mini:
		spawn_minis()
	super.die()

func spawn_minis():
	for i in range(2):
		var mini = load("res://scenes/Enemy/ChocolateSlime.tscn").instantiate()
		mini.is_mini = true
		mini.global_position = global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
		get_tree().current_scene.add_child(mini)
