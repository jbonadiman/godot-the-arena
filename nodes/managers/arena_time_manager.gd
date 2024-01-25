extends Node
class_name ArenaTimeManager

@export var victory_screen_scene: PackedScene

@onready var timer: Timer = $Timer


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func _on_timer_timeout() -> void:
	var victory_screen_instance = victory_screen_scene.instantiate()
	add_child(victory_screen_instance)
