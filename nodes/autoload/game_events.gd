extends Node

signal experience_vial_collected(number: float)
signal arena_difficulty_increased(arena_difficulty: int)
signal ability_upgrades_added(upgrade: Upgrade, current_upgrades: Dictionary)
signal player_damaged
signal health_regen_tick


func emit_health_regen_tick() -> void:
	health_regen_tick.emit()


func emit_experience_vial_collected(number: float) -> void:
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(
	upgrade: Upgrade,
	current_upgrades: Dictionary) -> void:

	ability_upgrades_added.emit(upgrade, current_upgrades)


func emit_player_damaged() -> void:
	player_damaged.emit()
