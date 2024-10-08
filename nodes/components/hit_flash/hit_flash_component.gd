class_name HitFlashComponent
extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	health_component.decreased.connect(_on_health_decreased)
	sprite.material = hit_flash_material


func _on_health_decreased() -> void:
	if hit_flash_tween and hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	(sprite.material as ShaderMaterial).set_shader_parameter(
		"lerp_percentage",
		1.0)

	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(
		sprite.material,
		"shader_parameter/lerp_percentage",
		0.0,
		0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
