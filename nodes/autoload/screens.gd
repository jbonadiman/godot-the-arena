extends CanvasLayer

signal transitioned_halfway

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var color_rect: ColorRect = %ColorRect

var main_menu_scene = preload("res://nodes/ui/main_menu.tscn")
var options_menu_scene = preload("res://nodes/ui/options_menu.tscn")
var pause_menu_scene = preload("res://nodes/ui/pause_menu.tscn")
var upgrades_menu_scene = preload("res://nodes/ui/meta_menu.tscn")

var upgrade_card_scene = preload("res://nodes/ui/upgrade_card.tscn")
var meta_upgrade_card_scene = preload("res://nodes/ui/meta_upgrade_card.tscn")

var end_scene = preload("res://nodes/screens/end_screen.tscn")
var main_scene = preload("res://nodes/screens/main.tscn")


func transition_to_scene(scene: PackedScene) -> void:
	transition()
	await transitioned_halfway
	get_tree().change_scene_to_packed(scene)


func transition() -> void:
	color_rect.visible = true

	animation_player.play("default")
	await animation_player.animation_finished

	transitioned_halfway.emit()

	animation_player.play_backwards("default")
	await animation_player.animation_finished

	color_rect.visible = false
