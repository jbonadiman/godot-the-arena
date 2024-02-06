class_name ExperienceVial
extends Node2D

@onready var area_2d: Area2D = %Area2D
@onready var collision_shape: CollisionShape2D = %CollisionShape2D
@onready var sprite: Sprite2D = %Sprite2D
@onready var audio_player: RandomStreamPlayer2DComponent = \
	%RandomStreamPlayer2DComponent

var player: Player


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	player = get_tree().get_first_node_in_group("player")


func _collect() -> void:
	audio_player.play_random()
	await audio_player.finished

	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func _on_area_entered(_other_area: Area2D) -> void:
	_disable_collision.call_deferred()

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(_tween_collect.bind(global_position), 0.0, 1.0, 0.5) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)

	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(_collect)


func _disable_collision() -> void:
	collision_shape.disabled = true


func _tween_collect(percent: float, start_position: Vector2) -> void:
	if not player:
		push_error("player not found")

	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start := player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)

	rotation = lerp_angle(
		rotation,
		target_rotation,
		1 - exp(-2 * get_process_delta_time()))
