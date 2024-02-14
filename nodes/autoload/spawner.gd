extends Node


func get_enemy_closest_to(target: Node2D, within_range: float) -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemy") as Array
	enemies = enemies.filter(
		func(enemy: Node2D):
			return enemy.global_position \
			.distance_squared_to(target.global_position) <= within_range)

	if enemies.is_empty():
		return null

	enemies.sort_custom(
		func(this: Node2D, other: Node2D):
			var this_distance = \
				this.global_position.distance_squared_to(target.global_position)
			var other_distance = \
				other.global_position.distance_squared_to(target.global_position)
			return this_distance < other_distance)

	return enemies.front()


func get_position_inside_arena(radius: float) -> Vector2:
	var player := get_tree().get_first_node_in_group("player") as Player
	if not player:
		push_error("player not found")
		return Vector2.ZERO

	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4:
		spawn_position = player.global_position + \
			(random_direction * radius)

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
