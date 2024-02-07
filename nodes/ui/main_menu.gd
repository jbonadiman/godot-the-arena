class_name MainMenu
extends CanvasLayer

@onready var play_button: SoundButton = %PlayButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton

var options_scene := preload("res://nodes/ui/options_menu.tscn")


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://nodes/screens/main.tscn")


func _on_options_pressed() -> void:
	var instance := options_scene.instantiate() as OptionsMenu
	add_child(instance)
	instance.back_pressed.connect(_on_options_closed.bind(instance))


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_closed(options_instance: OptionsMenu) -> void:
	options_instance.queue_free()
