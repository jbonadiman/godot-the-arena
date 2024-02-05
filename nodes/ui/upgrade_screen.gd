class_name UpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: Upgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[Upgrade]) -> void:
	var animation_delay_sec := 0.0

	for upgrade in upgrades:
		var card_instance := upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)

		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(animation_delay_sec)
		card_instance.selected.connect(_on_upgrade_selected.bind(upgrade))

		animation_delay_sec += 0.2


func _on_upgrade_selected(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)

	animation_player.play("out")
	await animation_player.animation_finished

	get_tree().paused = false
	queue_free()
