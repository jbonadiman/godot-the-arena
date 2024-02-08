class_name PauseMenu
extends CanvasLayer

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var panel_container: PanelContainer = %PanelContainer

@onready var resume_button: SoundButton = %ResumeButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton

var options_menu_scene := preload("res://nodes/ui/options_menu.tscn")
var is_closing := false


func _ready() -> void:
	get_tree().paused = true
	panel_container.pivot_offset = panel_container.size / 2

	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	animation_player.play("default")

	var tween := create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_close()
		get_tree().root.set_input_as_handled()


func _close() -> void:
	if is_closing:
		return

	is_closing = true
	animation_player.play_backwards("default")

	var tween := create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_BACK)

	await tween.finished

	get_tree().paused = false
	queue_free()



func _on_resume_pressed() -> void:
	_close()


func _on_options_pressed() -> void:
	var instance := options_menu_scene.instantiate() as OptionsMenu
	add_child(instance)
	instance.back_pressed.connect(_on_options_back_pressed.bind(instance))


func _on_options_back_pressed(options_menu: OptionsMenu) -> void:
	options_menu.queue_free()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://nodes/ui/main_menu.tscn")
