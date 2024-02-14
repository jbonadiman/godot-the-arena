extends Node
class_name SwordAbilityController


@onready var timer: Timer = %Timer
@onready var base_wait_time := timer.wait_time

const BASE_DAMAGE := 5
const MAX_RANGE := 60.0
const UPGRADE_PERCENTAGE := 0.1

var additional_damage_percent := 1.0
var foreground_layer: Node2D


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(_on_ability_upgrade_added)
	foreground_layer = get_tree() \
		.get_first_node_in_group("foreground_layer") as Node2D


func on_timer_timeout() -> void:
	var player := get_tree().get_first_node_in_group("player") as Player
	if not player:
		push_error("player not found")
		return

	var closest_enemy := \
		Spawner.get_enemy_closest_to(player, pow(MAX_RANGE, 2))

	if not closest_enemy:
		return

	var sword_instance := Scenes.sword_ability.instantiate() as SwordAbility
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = \
		BASE_DAMAGE * additional_damage_percent

	sword_instance.global_position = \
		closest_enemy.global_position \
		+ Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction := \
		closest_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func _on_ability_upgrade_added(
	upgrade: Upgrade,
	current_upgrades: Dictionary) -> void:

	match upgrade.id:
		"sword_rate":
			var percent_reduction = \
			current_upgrades["sword_rate"]["quantity"] * UPGRADE_PERCENTAGE
			timer.wait_time = base_wait_time * (1 - percent_reduction)
			timer.start()

			print("sword wait time: %.2fs" % timer.wait_time)

		"sword_damage":
			additional_damage_percent = \
				1 + current_upgrades["sword_damage"]["quantity"] * 0.15
			print("sword add damage: %.2f" % additional_damage_percent)
