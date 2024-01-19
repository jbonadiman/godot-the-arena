extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10

var current_health

func _ready() -> void:
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0)
	if current_health == 0:
		Callable(die).call_deferred()


func die() -> void:
	died.emit()
	owner.queue_free()
