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
	position += direction * speed * delta

func _on_body_entered(body):
	if is_in_group("enemy_projectile"):
		if body.is_in_group("player"):
			body.take_damage(damage)
			queue_free()
	else:
		if body.is_in_group("enemy"):
			body.take_damage(damage)
			queue_free()
