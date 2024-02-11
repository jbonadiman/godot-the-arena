class_name AnvilAbility
extends Node

@onready var _hit_box_component: HitBoxComponent = %HitBoxComponent

var damage: float : set = _set_damage, get = _get_damage


func _get_damage() -> float:
	return _hit_box_component.damage


func _set_damage(value: float) -> void:
	_hit_box_component.damage = value
