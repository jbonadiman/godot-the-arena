extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var color_rect: ColorRect = %ColorRect


func transition_to_scene(scene: PackedScene) -> void:
	transition()
	await transitioned_halfway

	get_tree().paused = false
	get_tree().change_scene_to_packed(scene)


func transition() -> void:
	color_rect.visible = true

	animation_player.play("default")
	await animation_player.animation_finished

	transitioned_halfway.emit()

	animation_player.play_backwards("default")
	await animation_player.animation_finished

	color_rect.visible = false
