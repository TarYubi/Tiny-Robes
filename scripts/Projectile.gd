extends Area2D
class_name Projectile

var direction: Vector2 = Vector2.RIGHT
var speed: float = 300.0
var damage: float = 10.0
var lifetime: float = 5.0

func _ready():
	body_entered.connect(_on_body_entered)
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(queue_free)

func _physics_process(delta):
	if is_in_group("homing"):
		var enemies = get_tree().get_nodes_in_group("enemy")
		if not enemies.is_empty():
			var nearest = enemies[0]
			var min_dist = global_position.distance_to(nearest.global_position)
			for e in enemies:
				var d = global_position.distance_to(e.global_position)
				if d < min_dist:
					min_dist = d
					nearest = e

			var target_dir = (nearest.global_position - global_position).normalized()
			direction = direction.lerp(target_dir, 5.0 * delta).normalized()
			rotation = direction.angle()

	position += direction * speed * delta

func _on_body_entered(body):
	if is_in_group("enemy_projectile"):
		if body.is_in_group("player"):
			body.take_damage(damage)
			queue_free()
	else:
		if body.is_in_group("enemy"):
			body.take_damage(damage)
			if is_in_group("bouncing"):
				direction = direction.rotated(PI/2) # Simple bounce
				rotation = direction.angle()
			else:
				queue_free()
		elif body is StaticBody2D: # Wall
			if is_in_group("bouncing"):
				direction = direction.rotated(PI) # Bounce back
				rotation = direction.angle()
			else:
				queue_free()
