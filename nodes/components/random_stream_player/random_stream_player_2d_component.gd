class_name RandomStreamPlayer2DComponent
extends AudioStreamPlayer2D

@export var streams: Array[AudioStream]


func play_random() -> void:
	if not streams or streams.is_empty():
		return

	stream = streams.pick_random()
	play()
