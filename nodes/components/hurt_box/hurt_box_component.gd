extends Area2D
class_name  HurtBoxComponent

@export var health_component: HealthComponent

var floating_text_scene := preload("res://nodes/ui/floating_text.tscn")
var foreground_layer: Node2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	foreground_layer = get_tree().get_first_node_in_group("foreground_layer")

func _on_area_entered(other_area: Area2D) -> void:
	if not health_component:
		push_error("health_component not found")
		return

	if not foreground_layer:
		push_error("foreground_layer not found")
		return

	var hit_box = other_area as HitBoxComponent
	if not hit_box:
		push_error("hit_box not found")
		return

	health_component.damage(hit_box.damage)

	var floating_text := floating_text_scene.instantiate() as FloatingText
	foreground_layer.add_child(floating_text)

	floating_text.global_position = \
		global_position + (Vector2.UP * (floating_text.height / 2.0))
	floating_text.initialize(str(hit_box.damage))
