class_name AbilityUpgradeCard
extends PanelContainer

signal submitted

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var hover_animation_player: AnimationPlayer = %HoverAnimationPlayer

var disabled := false
var hovered := false


func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func play_in(delay_sec := 0.0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay_sec).timeout
	animation_player.play("in")


func play_discard() -> void:
	animation_player.play("discard")


func hover() -> void:
	if disabled:
		return

	hovered = true
	hover_animation_player.play("hover")
	animation_player.play("selected")


func unhover() -> void:
	if disabled:
		return
	animation_player.play("RESET")
	hovered = false


func submit() -> void:
	disabled = true
	animation_player.play("submitted")

	var upgrade_cards := get_tree().get_nodes_in_group("upgrade_card")

	for other_card: AbilityUpgradeCard in upgrade_cards:
		if other_card == self:
			continue
		other_card.play_discard()

	await animation_player.animation_finished
	submitted.emit()


func set_ability_upgrade(upgrade: Upgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return

	if event.is_action_pressed("left_click"):
		submit()


func _on_mouse_entered() -> void:
	hover()


func _on_mouse_exited() -> void:
	unhover()
