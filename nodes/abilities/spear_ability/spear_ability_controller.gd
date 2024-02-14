class_name SpearAbilityController
extends Node

@onready var timer: Timer = %Timer

const BASE_INTERVAL_SECS := 1.3
const BASE_DAMAGE := 7
const MAX_RANGE := 60.0

var increased_rate_percent := 0.1
var additional_damage_percent := 1.0
var foreground_layer: Node2D
var player: Node2D


func _ready() -> void:
	timer.wait_time = BASE_INTERVAL_SECS
	timer.timeout.connect(on_timer_timeout)
	# TODO:
	#GameEvents.ability_upgrades_added.connect(_on_ability_upgrade_added)
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D
	player = get_tree().get_first_node_in_group("player") as Node2D


func on_timer_timeout() -> void:
	if not player:
		push_error("player not found")
		return

	var closest_enemy := \
		Spawner.get_enemy_closest_to(player, pow(MAX_RANGE, 2))

	if not closest_enemy:
		return

	var instance := Scenes.spear_ability.instantiate() as SpearAbility
	instance.global_position = player.global_position

	var dir = closest_enemy.global_position.direction_to(player.global_position)
	instance.rotation = dir.angle()

	foreground_layer.add_child(instance)

	instance.hitbox_component.damage = \
		BASE_DAMAGE * additional_damage_percent

# TODO: add upgrades
#func _on_ability_upgrade_added(
	#upgrade: Upgrade,
	#current_upgrades: Dictionary) -> void:
#
	#match upgrade.id:
		#"sword_rate":
			#var percent_reduction = \
			#current_upgrades["sword_rate"]["quantity"] * UPGRADE_PERCENTAGE
			#timer.wait_time = base_wait_time * (1 - percent_reduction)
			#timer.start()
#
			#print("sword wait time: %.2fs" % timer.wait_time)
#
		#"sword_damage":
			#additional_damage_percent = \
				#1 + current_upgrades["sword_damage"]["quantity"] * 0.15
			#print("sword add damage: %.2f" % additional_damage_percent)
