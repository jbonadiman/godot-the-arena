class_name UpgradeManager
extends Node

@export var upgrade_pool: Array[Upgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades := {}


func _ready() -> void:
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
			upgrade_pool = upgrade_pool.filter(
				func(pool_upgrade):
					return pool_upgrade.id != upgrade.id)

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades() -> Array[Upgrade]:
	var filtered_upgrades := upgrade_pool.duplicate()
	var chosen_upgrades: Array[Upgrade] = []
	for i in 2:
		if filtered_upgrades.is_empty():
			break

		var chosen_upgrade := filtered_upgrades.pick_random() as Upgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(
			func(upgrade):
				return upgrade.id != chosen_upgrade.id)

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
