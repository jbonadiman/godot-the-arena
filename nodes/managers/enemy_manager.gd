extends Node
class_name EnemyManager

@export var basic_enemy_scene: PackedScene

@onready var timer: Timer = $Timer
@onready var spawn_radius: int

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	spawn_radius = int(get_viewport() \
		.get_visible_rect() \
		.size.x / 2) + 60

func on_timer_timeout() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if not player:
		return

	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position := player.global_position + \
		(random_direction * spawn_radius)

	var enemy := basic_enemy_scene.instantiate() as Node2D
	get_parent().add_child(enemy)
	enemy.global_position = spawn_position
