class_name AxeAbility
extends Node2D

@onready var hitbox_component: HitBoxComponent = $HitBoxComponent

const MAX_RADIUS = 100

var base_rotation: Vector2
var player: Player

func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

	var tween = create_tween()
	tween.tween_method(_tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)
	player = get_tree().get_first_node_in_group("player")


func _tween_method(rotations: float) -> void:
	var percentage := rotations / 2
	var current_radius := percentage * MAX_RADIUS
	var current_direction := base_rotation.rotated(rotations * TAU)

	if not player:
		push_warning("player not found")
		return

	global_position = \
		player.global_position + (current_direction * current_radius)


