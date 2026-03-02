extends EnemyBase

@onready var max_health = health

func _physics_process(delta):
	super._physics_process(delta)

	# Melt mechanic: scale Y down as health decreases
	var health_percent = health / max_health
	$Sprite2D.scale.y = lerp(0.5, 1.0, health_percent)
	$Sprite2D.scale.x = lerp(1.5, 1.0, health_percent)

	# Slow down as it melts
	speed = lerp(30.0, 60.0, health_percent)
