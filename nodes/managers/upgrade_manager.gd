extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager

var current_upgrades := {}


func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)


func on_level_up(_new_level: int):
	var chosen_upgrade := upgrade_pool.pick_random() as AbilityUpgrade
	if not chosen_upgrade:
		return

	var has_upgrade := current_upgrades.has(chosen_upgrade.id)
	if not has_upgrade:
		current_upgrades[chosen_upgrade.id] = {
			"resource": chosen_upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
	print(current_upgrades)
