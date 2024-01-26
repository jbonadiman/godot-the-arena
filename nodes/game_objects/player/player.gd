extends CharacterBody2D
class_name Player

@onready var health_component: HealthComponent = %HealthComponent
@onready var damage_interval_timer: Timer = %DamageIntervalTimer

const MAX_PLAYER = 125
const ACCELERATION_SMOOTHING = 25

var total_colliding_bodies := 0


func _process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	var direction := movement_vector.normalized()

	var target_velocity = direction * MAX_PLAYER
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("move_right") \
		- Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") \
		- Input.get_action_strength("move_up")

	return Vector2(x_movement, y_movement)


func check_deal_damage() -> void:
	if not health_component:
		push_error("health_component not found")
		return

	if not total_colliding_bodies or not damage_interval_timer.is_stopped():
		return

	health_component.damage(1)
	damage_interval_timer.start()

	print(health_component.current_health)


func _on_body_entered(_other_body: Node2D) -> void:
	total_colliding_bodies += 1
	check_deal_damage()


func _on_body_exited(_other_body: Node2D) -> void:
	total_colliding_bodies -= 1


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()
