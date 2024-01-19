extends Node
class_name SwordAbilityController

@export var max_range := 150.0
@export var sword_ability: PackedScene

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	var enemies := get_tree().get_nodes_in_group("enemy") as Array[Node]
	enemies = enemies.filter(
		func(enemy: Node2D):
			return enemy.global_position \
			.distance_squared_to(player.global_position) <= pow(max_range, 2))

	if enemies.is_empty():
		return

	enemies.sort_custom(
		func(this: Node2D, other: Node2D):
			var this_distance = \
				this.global_position.distance_squared_to(player.global_position)
			var other_distance = \
				other.global_position.distance_squared_to(player.global_position)
			return this_distance < other_distance)

	var sword_instance := sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies.front().global_position
