class_name RandomStreamPlayerComponent
extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var min_pitch := 0.9
@export var max_pitch := 1.1


func play_random() -> void:
	if not streams or streams.is_empty():
		return

	pitch_scale = randf_range(min_pitch, max_pitch) if randomize_pitch else 1.0

	stream = streams.pick_random()
	play()
