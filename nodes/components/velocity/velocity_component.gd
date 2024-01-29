class_name VelocityComponent
extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5.0

var player: Player
var velocity := Vector2.ZERO


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func accelerate_towards_player() -> void:
	var owner_node2d := owner as Node2D
	if not owner_node2d:
		push_error("owner not found")
		return

	if not player:
		push_error("player not found")
		return

	var direction = (player.global_position - owner_node2d.global_position) \
		.normalized()
	accelerate_towards(direction)


func accelerate_towards(direction: Vector2) -> void:
	var target_velocity := direction * max_speed
	velocity = velocity.lerp(
		target_velocity,
		1 - exp(-acceleration * get_process_delta_time()))


func move(character_body: CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()

	velocity = character_body.velocity
