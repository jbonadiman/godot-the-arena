class_name OptionsMenu
extends CanvasLayer

signal back_pressed

@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_mode_button: SoundButton = %WindowModeButton
@onready var back_button: SoundButton = %BackButton

const WINDOW := DisplayServer.WINDOW_MODE_WINDOWED
const FULLSCREEN := DisplayServer.WINDOW_MODE_FULLSCREEN


func _ready() -> void:
	window_mode_button.pressed.connect(_on_window_mode_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	sfx_slider.value_changed.connect(
		_on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(
		_on_audio_slider_changed.bind("music"))

	update_display()


func update_display() -> void:
	window_mode_button.text = "Fullscreen" \
		if DisplayServer.window_get_mode() == WINDOW \
		else "Windowed"

	sfx_slider.value = get_bus_volume_percentage("sfx")
	music_slider.value = get_bus_volume_percentage("music")


func get_bus_volume_percentage(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var bus_volume = AudioServer.get_bus_volume_db(bus_index)

	return db_to_linear(bus_volume)


func set_bus_volume_percentage(bus_name: String, percentage: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(percentage))


func _on_window_mode_button_pressed() -> void:
	match DisplayServer.window_get_mode():
		FULLSCREEN:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(WINDOW)

		_:
			DisplayServer.window_set_mode(FULLSCREEN)

	update_display()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percentage(bus_name, value)


func _on_back_button_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway

	back_pressed.emit()
