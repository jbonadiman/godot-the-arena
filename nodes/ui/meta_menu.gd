class_name MetaMenu
extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container: GridContainer = %GridContainer

var meta_upgrade_card_scene = preload("res://nodes/ui/meta_upgrade_card.tscn")


func _ready():
	for upgrade in upgrades:
		var card := meta_upgrade_card_scene.instantiate() as MetaUpgradeCard
		grid_container.add_child(card)

		card.upgrade = upgrade
