extends Node2D

@export var wall_scenes: Array[PackedScene]
@export var enemy_scenes: Array[PackedScene]
@export var arena_size: Vector2 = Vector2(1200, 800)
@export var sugar_cube_size: float = 32.0

var current_wave: int = 0
var wave_timer: Timer

# Wave definitions: { "enemies": [ScenePath, ...], "count": int, "delay": float }
var wave_data = [
	{ "enemies": ["res://scenes/Enemy/Bunny.tscn"], "count": 8, "delay": 2.0 },
	{ "enemies": ["res://scenes/Enemy/Bunny.tscn", "res://scenes/Enemy/GummyBear.tscn"], "count": 12, "delay": 1.5 },
	{ "enemies": ["res://scenes/Enemy/JellyfishCandy.tscn", "res://scenes/Enemy/MarshmallowGhost.tscn"], "count": 15, "delay": 1.2 },
	{ "enemies": ["res://scenes/Enemy/LollipopKnight.tscn", "res://scenes/Enemy/ChocolateSlime.tscn"], "count": 18, "delay": 1.0 },
	{ "enemies": ["res://scenes/Enemy/PeppermintSpinner.tscn", "res://scenes/Enemy/SourPatchGremlin.tscn"], "count": 20, "delay": 0.8 },
	{ "enemies": ["res://scenes/Enemy/Bunny.tscn", "res://scenes/Enemy/GummyBear.tscn", "res://scenes/Enemy/LollipopKnight.tscn", "res://scenes/Enemy/CupcakeBomber.tscn", "res://scenes/Enemy/ChocolateGolem.tscn", "res://scenes/Enemy/MarshmallowGhost.tscn", "res://scenes/Enemy/JellyfishCandy.tscn", "res://scenes/Enemy/ChocolateSlime.tscn", "res://scenes/Enemy/PeppermintSpinner.tscn", "res://scenes/Enemy/SourPatchGremlin.tscn"], "count": 30, "delay": 0.5 }
]

func _ready():
	generate_arena()
	# Wait a frame to ensure all nodes are in groups
	await get_tree().process_frame

	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.wait_time = 35.0 # Slightly longer waves
	wave_timer.timeout.connect(_on_wave_timer_timeout)

	start_next_wave()

func start_next_wave():
	current_wave += 1
	if current_wave > wave_data.size():
		print("All waves complete!")
		return

	GameManager.player_leveled_up.emit(current_wave)
	spawn_wave_data(current_wave - 1)
	wave_timer.start()

func _on_wave_timer_timeout():
	GameManager.wave_completed.emit(current_wave)
	start_next_wave()

func generate_arena():
	# Simple rectangular arena with sugar cube walls
	var half_size = arena_size / 2.0

	# Top and Bottom walls
	for x in range(int(-half_size.x), int(half_size.x + sugar_cube_size), int(sugar_cube_size)):
		spawn_wall(Vector2(x, -half_size.y))
		spawn_wall(Vector2(x, half_size.y))

	# Left and Right walls
	for y in range(int(-half_size.y + sugar_cube_size), int(half_size.y), int(sugar_cube_size)):
		spawn_wall(Vector2(-half_size.x, y))
		spawn_wall(Vector2(half_size.x, y))

func spawn_wall(pos: Vector2):
	var wall = wall_scenes.pick_random().instantiate()
	wall.position = pos
	add_child(wall)

func spawn_wave_data(wave_index: int):
	var data = wave_data[wave_index]
	var count = data["count"]
	var delay = data["delay"]

	for i in range(count):
		var scene_path = data["enemies"].pick_random()
		var enemy = load(scene_path).instantiate()

		# Edge spawning
		var spawn_pos = get_edge_spawn_pos()
		enemy.position = spawn_pos

		# Scaling difficulty
		enemy.speed += (current_wave * 5.0)
		enemy.health += (current_wave * 10.0)

		add_child(enemy)
		if delay > 0:
			await get_tree().create_timer(delay / 2.0).timeout

func get_edge_spawn_pos() -> Vector2:
	var side = randi() % 4
	var pos = Vector2.ZERO
	var margin = 50.0

	match side:
		0: # Top
			pos = Vector2(randf_range(-arena_size.x/2, arena_size.x/2), -arena_size.y/2 - margin)
		1: # Bottom
			pos = Vector2(randf_range(-arena_size.x/2, arena_size.x/2), arena_size.y/2 + margin)
		2: # Left
			pos = Vector2(-arena_size.x/2 - margin, randf_range(-arena_size.y/2, arena_size.y/2))
		3: # Right
			pos = Vector2(arena_size.x/2 + margin, randf_range(-arena_size.y/2, arena_size.y/2))

	return pos
