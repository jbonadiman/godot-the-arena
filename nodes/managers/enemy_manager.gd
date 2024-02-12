class_name EnemyManager
extends Node

@export var debug_draw: DebugDraw

@onready var timer: Timer = $Timer

var base_spawn_time := 0.0
var spawn_radius: int
var entities_layer: Node2D
var enemy_table := WeightedTable.new()


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	GameEvents.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

	base_spawn_time = timer.wait_time

	enemy_table.add_item(Scenes.basic_enemy, 10)

	#TODO: This needs better care. The arena needs a minimum size for this to
	# work
	spawn_radius = int(get_viewport() \
		.get_visible_rect() \
		.size.x / 2) + 50

	entities_layer = get_tree() \
		.get_first_node_in_group("entities_layer")


func _on_timer_timeout() -> void:
	timer.start()

	var enemy_scene = enemy_table.pick_item()

	var instance: Node2D = enemy_scene.instantiate()# as BasicEnemy
	entities_layer.add_child(instance)
	instance.global_position = Spawner.get_position_inside_arena(spawn_radius)


func _on_arena_difficulty_increased(arena_difficulty: int):
	var time_off := (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	print("enemy spawn decreased by: %.2fs" % time_off)
	timer.wait_time = base_spawn_time - time_off

	match arena_difficulty:
		6:
			enemy_table.add_item(Scenes.wizard_enemy, 15)
		18:
			enemy_table.add_item(Scenes.bat_enemy, 8)
