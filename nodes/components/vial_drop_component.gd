extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene


func _ready() -> void:
	health_component.died.connect(on_died)


func on_died():
	if randf() > drop_percent:
		return

	var parent := owner as Node2D
	if not parent:
		return

	var spawn_position = parent.global_position
	var vial_instance := vial_scene.instantiate() as Node2D

	parent.get_parent().add_child(vial_instance)
	vial_instance.global_position = spawn_position
