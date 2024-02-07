class_name EndScreen
extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var restart_button: SoundButton = %RestartButton
@onready var quit_button: SoundButton = %QuitButton


func _ready() -> void:
	restart_button.pressed.connect(_on_restart_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	panel_container.pivot_offset = panel_container.size / 2

	var tween := create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)

	get_tree().paused = true


func play_jingle(is_defeat := false) -> void:
	if is_defeat:
		%DefeatStreamPlayer.play()
	else:
		%VictoryStreamPlayer.play()


func set_defeat() -> void:
	title_label.text = "Defeat"
	description_label.text = "You lost!"
	play_jingle(true)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/screens/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
