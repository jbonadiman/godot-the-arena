class_name UpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: Upgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var card_controls: Array[AbilityUpgradeCard]


func _ready() -> void:
	card_controls = []
	get_tree().paused = true


func _toggle_card(
	select_card: AbilityUpgradeCard,
	unselect_card: AbilityUpgradeCard) -> void:

	unselect_card.unhover()
	if select_card.hovered:
		select_card.submit()
	else:
		select_card.hover()


func _unhandled_input(event: InputEvent) -> void:
	var first_card := card_controls[0]
	var second_card := card_controls[1]

	if event.is_action_released("select_first"):
		_toggle_card(first_card, second_card)
		get_tree().root.set_input_as_handled()

	elif event.is_action_released("select_second"):
		_toggle_card(second_card, first_card)
		get_tree().root.set_input_as_handled()



func set_ability_upgrades(upgrades: Array[Upgrade]) -> void:
	var animation_delay_sec := 0.0

	for upgrade in upgrades:
		var card_instance := upgrade_card_scene.instantiate() as AbilityUpgradeCard
		card_container.add_child(card_instance)

		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(animation_delay_sec)
		card_instance.submitted.connect(_on_upgrade_submitted.bind(upgrade))

		animation_delay_sec += 0.2
		card_controls.append(card_instance)


func _on_upgrade_submitted(upgrade: Upgrade) -> void:
	upgrade_selected.emit(upgrade)

	animation_player.play("out")
	await animation_player.animation_finished

	get_tree().paused = false
	queue_free()
