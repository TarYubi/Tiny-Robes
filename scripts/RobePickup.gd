extends Area2D

@export var robe_data: RobeData

func _ready():
	if robe_data:
		$Sprite2D.texture = robe_data.sprite_texture
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.equip_robe(robe_data)
		queue_free()
