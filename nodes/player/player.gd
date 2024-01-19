extends CharacterBody2D
class_name Player

const MAX_PLAYER = 200


func _process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	var direction := movement_vector.normalized()

	velocity = direction * MAX_PLAYER
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") \
		- Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") \
		- Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement)
