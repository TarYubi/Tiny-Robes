extends CharacterBody2D
class_name EnemyBase

@export var speed: float = 100.0
@export var health: float = 30.0
@export var damage: float = 10.0
@export var score_value: int = 10

var player: CharacterBody2D

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

		# Flip sprite based on direction
		if velocity.x != 0:
			$Sprite2D.flip_h = velocity.x < 0

		# Wobble animation
		var time = Time.get_ticks_msec() / 150.0 + get_instance_id()
		$Sprite2D.rotation = sin(time) * 0.1

func take_damage(amount: float):
	health -= amount
<<<<<<< HEAD

	# Hit flash
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)

	# Slight knockback
	if player:
		var knockback_dir = (global_position - player.global_position).normalized()
		global_position += knockback_dir * 10.0

=======
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
	if health <= 0:
		die()

func die():
	GameManager.add_score(score_value)
	GameManager.enemy_defeated()
	# REPLACE WITH REAL PIXEL ART HERE (Candy explosion)
	spawn_death_effect()
	queue_free()

func spawn_death_effect():
	var effect_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if effect_scene:
		var effect = effect_scene.instantiate()
		effect.position = global_position
		# Match enemy color
		effect.process_material.color = $Sprite2D.modulate if $Sprite2D.modulate != Color.WHITE else Color(1, 0.5, 0.8)
		get_tree().current_scene.add_child(effect)
		effect.emitting = true

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
