class_name AnvilAbilityController
extends Node

const BASE_RANGE := 100.0
const BASE_DAMAGE := 15.0

@onready var timer: Timer = %Timer

var foreground_layer: Node2D


func _ready() -> void:
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	var instance := Scenes.anvil_ability.instantiate() as AnvilAbility
	foreground_layer.add_child(instance)

	instance.global_position = Spawner.get_position_inside_arena(BASE_RANGE)
	instance.damage = BASE_DAMAGE
