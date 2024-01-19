extends CanvasLayer
class_name ArenaTimeUI

@export var arena_time_manager: ArenaTimeManager

@onready var label = %Label


func _process(_delta: float) -> void:
	if not arena_time_manager:
		return

	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds(time_elapsed)


func format_seconds(seconds: float) -> String:
	var minutes: float = floor(seconds / 60)
	var remaining_seconds: float = seconds - (minutes * 60)
	return "%02.f:%02.f" % [minutes, remaining_seconds]
