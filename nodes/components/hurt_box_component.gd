extends Area2D
class_name  HurtBoxComponent

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D) -> void:
	if not health_component:
		push_error("health_component not found")
		return

	var hitbox_component = other_area as HitBoxComponent
	if not hitbox_component:
		push_error("hitbox_component not found")
		return

	health_component.damage(hitbox_component.damage)
