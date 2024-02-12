class_name AnvilAbilityController
extends Node

const BASE_RANGE := 100.0
const BASE_DAMAGE := 15.0

@onready var timer: Timer = %Timer

var anvil_count := 0
var foreground_layer: Node2D


func _ready() -> void:
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D
	timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	for i in anvil_count + 1:
		var anvil := Scenes.anvil_ability.instantiate() as AnvilAbility
		foreground_layer.add_child(anvil)

		anvil.global_position = Spawner.get_position_inside_arena(BASE_RANGE)
		anvil.damage = BASE_DAMAGE
		await anvil.hit_the_ground


func _on_ability_upgrade_added(
	upgrade: Upgrade,
	current_upgrades: Dictionary) -> void:

	match upgrade.id:
		"anvil_count":
			anvil_count = current_upgrades["anvil_count"]["quantity"]

