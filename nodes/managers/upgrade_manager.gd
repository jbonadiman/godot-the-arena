class_name UpgradeManager
extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades := {}
var upgrade_pool := WeightedTable.new()

var upgrade_anvil: Upgrade = preload("uid://000hbhxpnjwo")
var upgrade_axe: Upgrade = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage: Upgrade = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate: Upgrade = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage: Upgrade = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed: Upgrade = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil_count: Upgrade = preload("res://resources/upgrades/anvil_count.tres")

enum UpgradeRarity {
	COMMON = 10,
	UNCOMMON = 5,
	RARE = 1,
}


func _ready() -> void:
	upgrade_pool.add_item(upgrade_axe, UpgradeRarity.COMMON)
	upgrade_pool.add_item(upgrade_anvil, UpgradeRarity.COMMON)
	upgrade_pool.add_item(upgrade_sword_rate, UpgradeRarity.COMMON)
	upgrade_pool.add_item(upgrade_sword_damage, UpgradeRarity.COMMON)
	upgrade_pool.add_item(upgrade_player_speed, UpgradeRarity.UNCOMMON)

	experience_manager.level_up.connect(_on_level_up)


func apply_upgrade(upgrade: Upgrade) -> void:
	if not current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity:
		var current_quantity: int = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)

	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: Upgrade) -> void:
	match chosen_upgrade.id:
		upgrade_axe.id:
			upgrade_pool.add_item(upgrade_axe_damage, UpgradeRarity.COMMON)

		upgrade_anvil.id:
			upgrade_pool.add_item(upgrade_anvil_count, UpgradeRarity.UNCOMMON)


func pick_upgrades() -> Array[Upgrade]:
	var chosen_upgrades: Array[Upgrade] = []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break

		var chosen_upgrade := upgrade_pool.pick_item(chosen_upgrades) as Upgrade
		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades


func on_upgrade_selected(upgrade: Upgrade) -> void:
	apply_upgrade(upgrade)


func _on_level_up(_new_level: int):
	var upgrade_screen_instance := \
		upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)

	var chosen_upgrades := pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
