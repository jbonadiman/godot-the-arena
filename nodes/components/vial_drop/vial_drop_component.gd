extends Node
class_name VialDropComponent

@export_range(0, 1) var drop_percent: float = .5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

var entities_layer: Node2D


func _ready() -> void:
	health_component.died.connect(_on_died)

	entities_layer = get_tree() \
		.get_first_node_in_group("entities_layer") as Node2D


func _on_died() -> void:
	var adjusted_drop_percent := drop_percent
	var experience_gain_count := MetaProgression.get_upgrade_count("experience_gain")

	if experience_gain_count:
		adjusted_drop_percent += 0.1 * experience_gain_count

	if randf() > adjusted_drop_percent:
		return

	var parent := owner as Node2D
	if not parent:
		push_error("couldn't find parent")
		return

	var spawn_position = parent.global_position
	var vial_instance := vial_scene.instantiate() as Node2D

	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spawn_position
