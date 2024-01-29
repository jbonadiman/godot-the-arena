extends Area2D
class_name  HurtBoxComponent

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(other_area: Area2D) -> void:
	if not health_component:
		push_error("health_component not found")
		return

	var hit_box = other_area as HitBoxComponent
	if not hit_box:
		push_error("hit_box not found")
		return

	health_component.damage(hit_box.damage)
