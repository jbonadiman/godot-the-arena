extends CanvasLayer
class_name VictoryScreen


func _ready() -> void:
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/screens/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
