class_name MetaUpgradeCard
extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_label: Label = %ProgressLabel

var upgrade: MetaUpgrade : set = _set_meta_upgrade


func _ready() -> void:
	purchase_button.pressed.connect(_on_purchase_pressed)


func _select_card() -> void:
	animation_player.play("selected")


func update_progress() -> void:
	var currency: float = MetaProgression.save_data["meta_upgrade_currency"]

	var percent: float = currency / upgrade.experience_cost
	percent = min(percent, 1)

	progress_bar.value = percent
	purchase_button.disabled = percent < 1
	progress_label.text = "%0.0f/%d" % [currency, upgrade.experience_cost]


func _set_meta_upgrade(value: MetaUpgrade) -> void:
	upgrade = value
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func _on_purchase_pressed() -> void:
	if not upgrade:
		push_error("upgrade is null")
		return

	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.add_meta_upgrade(upgrade)

	get_tree().call_group("meta_upgrade_card", "update_progress")
	_select_card()
