class_name MainMenu
extends CanvasLayer

@onready var play_button: SoundButton = %PlayButton
@onready var upgrades_button: SoundButton = %UpgradesButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	upgrades_button.pressed.connect(_on_upgrades_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	ScreenTransition.transition_to_scene(Scenes.main_screen)


func _on_upgrades_pressed() -> void:
	ScreenTransition.transition_to_scene(Scenes.meta_upgrades_menu)


func _on_options_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway

	var instance := Scenes.options_menu.instantiate() as OptionsMenu
	add_child(instance)
	instance.back_pressed.connect(_on_options_closed.bind(instance))


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_closed(options_instance: OptionsMenu) -> void:
	options_instance.queue_free()
