extends CharacterBody2D
class_name EnemyBase

@export var speed: float = 100.0
@export var health: float = 30.0
@export var damage: float = 10.0
@export var score_value: int = 10
@export var death_color: Color = Color(1, 0.5, 0.8)
@export var death_particle_amount: int = 40

var player: CharacterBody2D

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

	# Pop-in animation
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Initial sparkle
	var effect = load("res://scenes/Effects/DeathParticles.tscn").instantiate()
	effect.position = global_position
	effect.amount = 10
	effect.one_shot = true
	get_tree().current_scene.add_child(effect)
	effect.emitting = true

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

	# Hit flash & Squash/Stretch using a single sequenced tween
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($Sprite2D, "scale", Vector2(1.2, 0.8), 0.1)

	tween.chain().set_parallel(true)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.1)

	# Slight knockback
	if player:
		var knockback_dir = (global_position - player.global_position).normalized()
		global_position += knockback_dir * 15.0

	if health <= 0:
		die()

func die():
	GameManager.add_score(score_value)
	GameManager.enemy_defeated()
	spawn_death_effect()
	queue_free()

func spawn_death_effect():
	# 1. Death Poof (White Cloud)
	var poof_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if poof_scene:
		var poof = poof_scene.instantiate()
		poof.position = global_position
		poof.amount = 20
		var mat = poof.process_material.duplicate()
		mat.color = Color(1, 1, 1, 0.8)
		mat.scale_min = 8.0
		mat.scale_max = 12.0
		poof.process_material = mat
		get_tree().current_scene.add_child(poof)
		poof.emitting = true

	# 2. Candy Explosion (Colored Shards)
	var candy_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if candy_scene:
		var effect = candy_scene.instantiate()
		effect.position = global_position
		effect.amount = death_particle_amount

		# Custom effects based on enemy type variables
		var mat = effect.process_material.duplicate()
		mat.color = death_color

		# Specialized logic for certain types if needed (e.g. peppermint shards)
		if "Peppermint" in name:
			mat.hue_variation_min = 0.0
			mat.hue_variation_max = 0.5 # Alternate red/white

		effect.process_material = mat
		get_tree().current_scene.add_child(effect)
		effect.emitting = true

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
