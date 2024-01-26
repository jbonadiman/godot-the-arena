extends CanvasLayer
class_name EndScreen

@onready var title_label := %TitleLabel
@onready var description_label := %DescriptionLabel


func _ready() -> void:
	get_tree().paused = true


func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "You lost!"


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/screens/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
