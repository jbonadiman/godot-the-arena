extends Node
class_name AxeAbilityController

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = %Timer

var damage := 10
var foreground_layer: Node2D


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D


func _on_timer_timeout() -> void:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	if not player:
		push_error("player not found")
		return

	var instance := axe_ability_scene.instantiate() as AxeAbility
	foreground_layer.add_child(instance)
	instance.global_position = player.global_position
	instance.hitbox_component.damage = damage
