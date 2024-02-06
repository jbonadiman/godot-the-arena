class_name Player
extends CharacterBody2D

@onready var health_component: HealthComponent = %HealthComponent
@onready var damage_interval_timer: Timer = %DamageIntervalTimer
@onready var abilities: Node = %Abilities
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var visuals: Node2D = %Visuals
@onready var collision_area_2d: Area2D = %CollisionArea2D

const MAX_PLAYER = 125
const ACCELERATION_SMOOTHING = 25

var total_colliding_bodies := 0


func _ready() -> void:
	GameEvents.ability_upgrades_added.connect(_on_ability_upgrade_added)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)
	collision_area_2d.body_entered.connect(_on_body_entered)
	collision_area_2d.body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	var movement_vector := get_movement_vector()
	var direction := movement_vector.normalized()

	var target_velocity = direction * MAX_PLAYER
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	move_and_slide()

	if movement_vector.x or movement_vector.y:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")

	var move_sign: int = sign(movement_vector.x)
	visuals.scale.x = move_sign if move_sign else 1


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


func _on_body_entered(_other_body: Node2D) -> void:
	total_colliding_bodies += 1
	check_deal_damage()


func _on_body_exited(_other_body: Node2D) -> void:
	total_colliding_bodies -= 1


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func _on_ability_upgrade_added(
	ability_upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	if not ability_upgrade is Ability:
		return

	abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())
