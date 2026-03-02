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

func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()

func die():
	GameManager.add_score(score_value)
	GameManager.enemy_defeated()
	queue_free()

func _on_hit_box_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
