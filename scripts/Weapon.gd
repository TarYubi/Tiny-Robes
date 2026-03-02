extends Node2D
class_name Weapon

@export var damage: float = 10.0
@export var fire_rate: float = 1.0 # Shots per second
@export var projectile_speed: float = 300.0
@export var projectile_scene: PackedScene

var timer: Timer
var player: CharacterBody2D

func _ready():
	# Search up the tree for the player
	var p = get_parent()
	while p and not p is CharacterBody2D:
		p = p.get_parent()
	player = p as CharacterBody2D

	if not player:
		push_error("Weapon %s could not find player!" % name)
		return

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0 / (fire_rate * player.stats.fire_rate_multiplier)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	attack()
	# Update timer in case stats changed
	timer.wait_time = 1.0 / (fire_rate * player.stats.fire_rate_multiplier)

func attack():
	pass # Override in subclasses
