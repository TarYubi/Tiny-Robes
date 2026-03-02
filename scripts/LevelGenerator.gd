extends Node2D

@export var wall_scenes: Array[PackedScene]
@export var enemy_scenes: Array[PackedScene]
@export var arena_size: Vector2 = Vector2(1200, 800)
@export var sugar_cube_size: float = 32.0

var current_wave: int = 0
var wave_timer: Timer

func _ready():
	generate_arena()
	# Wait a frame to ensure all nodes are in groups
	await get_tree().process_frame

	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.wait_time = 30.0 # 30 seconds per wave
	wave_timer.timeout.connect(_on_wave_timer_timeout)

	start_next_wave()

func start_next_wave():
	current_wave += 1
	if current_wave > 3:
		print("All waves complete!")
		return

	GameManager.player_leveled_up.emit(current_wave) # Reusing signal for wave info
	spawn_wave(current_wave)
	wave_timer.start()

func _on_wave_timer_timeout():
<<<<<<< HEAD
	GameManager.wave_completed.emit(current_wave)
=======
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
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

func spawn_wave(wave_num: int):
<<<<<<< HEAD
	# Refresh enemy scenes to include new ones if they were added via editor
	# but for this task we ensure they are present in the logic if needed
	# although normally we'd set them in the inspector.
	# Let's assume they are already in enemy_scenes or we can force them for verification.

=======
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
	var enemy_count = 5 + (wave_num * 3)
	for i in range(enemy_count):
		var enemy = enemy_scenes.pick_random().instantiate()
		# Spawn at random position within arena
		var spawn_pos = Vector2(
			randf_range(-arena_size.x/2 + 50, arena_size.x/2 - 50),
			randf_range(-arena_size.y/2 + 50, arena_size.y/2 - 50)
		)
		# Ensure it's not too close to player
		var player = get_tree().get_first_node_in_group("player")
		if player and spawn_pos.distance_to(player.global_position) < 200:
			spawn_pos += Vector2(200, 200) # Simple offset

		enemy.position = spawn_pos
		add_child(enemy)
