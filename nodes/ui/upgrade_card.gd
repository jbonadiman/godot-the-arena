class_name AbilityUpgradeCard
extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = %HoverAnimationPlayer

var disabled := false


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)


func play_in(delay_sec := 0.0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay_sec).timeout
	animation_player.play("in")


func play_discard() -> void:
	animation_player.play("discard")


func _select_card() -> void:
	disabled = true
	animation_player.play("selected")

	var upgrade_cards := get_tree().get_nodes_in_group("upgrade_card")

	for other_card: AbilityUpgradeCard in upgrade_cards:
		if other_card == self:
			continue
		other_card.play_discard()

	await animation_player.animation_finished
	selected.emit()


func set_ability_upgrade(upgrade: Upgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return

	if event.is_action_pressed("left_click"):
		_select_card()


func _on_mouse_entered() -> void:
	if disabled:
		return

	hover_animation_player.play("hover")
