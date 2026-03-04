extends CharacterBody2D
class_name EnemyBase

@export var speed: float = 100.0
@export var health: float = 30.0
@export var damage: float = 10.0
@export var score_value: int = 10

var player: CharacterBody2D
var renderer_3d: SubViewport

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

	if has_node("ViewportSprite/3DCharacterViewport"):
		renderer_3d = get_node("ViewportSprite/3DCharacterViewport")
		$ViewportSprite.texture = renderer_3d.get_texture()

		# Auto-load model based on scene name
		if "GummyBear" in name:
			renderer_3d.setup_model(load("res://assets/models/GummyBearModel.tscn"))
		elif "LollipopSoldier" in name:
			renderer_3d.setup_model(load("res://assets/models/LollipopSoldierModel.tscn"))

func _physics_process(_delta):
	if player:
		var dir = (player.global_position - global_position).normalized()
		velocity = dir * speed
		move_and_slide()

		# Rotation for 3D Viewport Sprite
		if velocity.length() > 0:
			$ViewportSprite.rotation = velocity.angle()
			if renderer_3d: renderer_3d.play_animation("walk")
		else:
			if renderer_3d: renderer_3d.play_animation("idle")

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()

func die():
	GameManager.add_score(score_value)
	GameManager.enemy_defeated()
	# REPLACE WITH REAL PIXEL ART HERE (Candy explosion)
	spawn_death_effect()
	# Optional: hide 3D model immediately
	if $ViewportSprite: $ViewportSprite.visible = false
	queue_free()

func spawn_death_effect():
	var effect_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if effect_scene:
		var effect = effect_scene.instantiate()
		effect.position = global_position
		# Match enemy color
		effect.process_material.color = Color(1, 0.5, 0.8)
		get_tree().current_scene.add_child(effect)
		effect.emitting = true

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
