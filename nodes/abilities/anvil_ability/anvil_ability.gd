class_name AnvilAbility
extends Node

signal hit_the_ground

@onready var _hit_box_component: HitBoxComponent = %HitBoxComponent

var damage: float : set = _set_damage, get = _get_damage


func _get_damage() -> float:
	return _hit_box_component.damage


func _set_damage(value: float) -> void:
	_hit_box_component.damage = value


func _emit_hit_the_ground() -> void:
	hit_the_ground.emit()
