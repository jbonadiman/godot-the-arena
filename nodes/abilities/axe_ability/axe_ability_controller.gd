class_name AxeAbilityController
extends Node

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage := 10
var additional_damage_percent := 1.0
var foreground_layer: Node2D
var player: Player


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D
	player = get_tree().get_first_node_in_group("player") as Player
	GameEvents.ability_upgrades_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	print("axe wait time: %ss" % timer.wait_time)

	if not player:
		push_error("player not found")
		return

	var instance := axe_ability_scene.instantiate() as AxeAbility
	foreground_layer.add_child(instance)
	instance.global_position = player.global_position
	instance.hitbox_component.damage = base_damage * additional_damage_percent


func _on_ability_upgrade_added(
	upgrade: Upgrade,
	current_upgrades: Dictionary) -> void:

	match upgrade.id:
		"axe_damage":
			additional_damage_percent = \
				1 + current_upgrades["axe_damage"]["quantity"] * 0.1
			print("axe add damage: %.2f" % additional_damage_percent)
