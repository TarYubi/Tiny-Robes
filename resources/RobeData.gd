extends Resource
class_name RobeData

@export var robe_name: String = "Basic Robe"
<<<<<<< HEAD
@export var sprite_texture: Texture2D
=======
@export var description: String = ""

@export_group("Visuals")
@export var base_texture: Texture2D
@export var trim_texture: Texture2D
@export var sleeves_texture: Texture2D
@export var shader_material: ShaderMaterial

@export_group("Stats")
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
@export var weapon_scene: PackedScene
@export var health_bonus: float = 0.0
@export var speed_bonus: float = 0.0
@export var damage_multiplier: float = 1.0
@export var fire_rate_multiplier: float = 1.0
