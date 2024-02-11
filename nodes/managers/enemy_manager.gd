class_name EnemyManager
extends Node

@export var arena_time_manager: ArenaTimeManager
@export var debug_draw: DebugDraw

@onready var timer: Timer = $Timer

var basic_enemy_scene := preload("res://nodes/game_objects/basic_enemy/basic_enemy.tscn")
var wizard_enemy_scene := preload("res://nodes/game_objects/wizard_enemy/wizard_enemy.tscn")
var bat_enemy_scene := preload("res://nodes/game_objects/bat_enemy/bat_enemy.tscn")

var base_spawn_time := 0.0
var spawn_radius: int
var entities_layer: Node2D
var enemy_table := WeightedTable.new()


func _ready() -> void:
	base_spawn_time = timer.wait_time

	enemy_table.add_item(basic_enemy_scene, 10)

	#TODO: This needs better care. The arena needs a minimum size for this to
	# work
	spawn_radius = int(get_viewport() \
		.get_visible_rect() \
		.size.x / 2) + 50

	entities_layer = get_tree() \
		.get_first_node_in_group("entities_layer")


func get_spawn_position() -> Vector2:
	var player := get_tree().get_first_node_in_group("player") as Player
	if not player:
		push_error("player not found")
		return Vector2.ZERO

	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4:
		spawn_position = player.global_position + \
			(random_direction * spawn_radius)

		var additional_check_offset := random_direction * 20

		var query_params = PhysicsRayQueryParameters2D.create(
			player.global_position,
			spawn_position + additional_check_offset,
			1)

		var raycast_result := get_tree() \
			.root \
			.world_2d \
			.direct_space_state \
			.intersect_ray(query_params)

		if raycast_result.is_empty():
			break

		random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func _on_timer_timeout() -> void:
	timer.start()

	var enemy_scene = enemy_table.pick_item()

	var instance: Node2D = enemy_scene.instantiate()# as BasicEnemy
	entities_layer.add_child(instance)
	instance.global_position = get_spawn_position()


func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off := (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	print("enemy spawn decreased by: %.2fs" % time_off)
	timer.wait_time = base_spawn_time - time_off

	match arena_difficulty:
		6:
			enemy_table.add_item(wizard_enemy_scene, 15)
		18:
			enemy_table.add_item(bat_enemy_scene, 8)
