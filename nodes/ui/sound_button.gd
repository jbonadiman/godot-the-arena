class_name SoundButton
extends Button

@onready var audio_player: RandomStreamPlayerComponent = \
  %RandomStreamPlayerComponent


func _ready() -> void:
  pressed.connect(_on_pressed)


func _on_pressed() -> void:
  audio_player.play_random()
