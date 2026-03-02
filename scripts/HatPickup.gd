extends Area2D

@export var hat_data: HatData

func _ready():
	if hat_data:
<<<<<<< HEAD
=======
		$Sprite2D.texture = hat_data.hat_texture
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
		$Sprite2D.self_modulate = hat_data.base_color
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.equip_hat(hat_data)
		queue_free()
