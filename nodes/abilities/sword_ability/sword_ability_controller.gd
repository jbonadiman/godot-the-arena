extends Node
class_name SwordAbilityController

@export var max_range := 150.0
@export var sword_ability_scene: PackedScene
@export var base_damage := 5

@onready var timer: Timer = $Timer
@onready var base_wait_time := timer.wait_time

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

	var enemies := get_tree().get_nodes_in_group("enemy") as Array
	enemies = enemies.filter(
		func(enemy: Node2D):
			return enemy.global_position \
			.distance_squared_to(player.global_position) <= pow(max_range, 2))

	if enemies.is_empty():
		return

	enemies.sort_custom(
		func(this: Node2D, other: Node2D):
			var this_distance = \
				this.global_position.distance_squared_to(player.global_position)
			var other_distance = \
				other.global_position.distance_squared_to(player.global_position)
			return this_distance < other_distance)

	var closest_enemy: Node2D = enemies.front()

	var sword_instance := sword_ability_scene.instantiate() as SwordAbility
	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = \
		base_damage * additional_damage_percent

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



