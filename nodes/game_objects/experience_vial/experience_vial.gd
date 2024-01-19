extends Node2D
class_name ExperienceVial

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(on_area_entered)


func on_area_entered(_other_area: Area2D) -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()
