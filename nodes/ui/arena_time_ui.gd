extends CanvasLayer
class_name ArenaTimeUI

@onready var label = %Label


func _process(_delta: float) -> void:
	label.text = format_seconds(GameTimers.elapsed_time)


func format_seconds(seconds: float) -> String:
	var minutes: float = floor(seconds / 60)
	var remaining_seconds: float = seconds - (minutes * 60)
	return "%02.f:%02.f" % [minutes, remaining_seconds]
