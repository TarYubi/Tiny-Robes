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

	# Hit flash
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, 0.1)

	# Slight knockback
	if player:
		var knockback_dir = (global_position - player.global_position).normalized()
		global_position += knockback_dir * 10.0

	if health <= 0:
		die()

func die():
	GameManager.add_score(score_value)
	GameManager.enemy_defeated()
	spawn_death_effect()
	queue_free()

func spawn_death_effect():
	var effect_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if effect_scene:
		var effect = effect_scene.instantiate()
		effect.position = global_position

		# Custom effects based on enemy type
		var mat = effect.process_material.duplicate()
		effect.process_material = mat
		if "Chocolate" in name:
			mat.color = Color(0.3, 0.2, 0.1)
			effect.amount = 60
		elif "Marshmallow" in name:
			mat.color = Color(1, 1, 1, 0.8)
			mat.scale_min = 4.0
			mat.scale_max = 8.0
		elif "Peppermint" in name:
			mat.color = Color(1, 0, 0) # Red/White shards
			mat.hue_variation_min = 0.0
			mat.hue_variation_max = 0.5 # Alternate red/white
		else:
			# Match enemy color
			mat.color = $Sprite2D.modulate if $Sprite2D.modulate != Color.WHITE else Color(1, 0.5, 0.8)

		get_tree().current_scene.add_child(effect)
		effect.emitting = true

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
