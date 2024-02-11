class_name MetaMenu
extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton


func _ready():
	back_button.pressed.connect(_on_back_button_pressed)

	for upgrade in upgrades:
		var card := \
			Scenes.meta_upgrade_card.instantiate() as MetaUpgradeCard
		grid_container.add_child(card)

		card.upgrade = upgrade


func _on_back_button_pressed():
	ScreenTransition.transition_to_scene(Scenes.main_menu)
