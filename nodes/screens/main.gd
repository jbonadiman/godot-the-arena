extends Node
class_name Main

@onready var player: Player = %Player


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("763b36"))
	GameTimers.start()
	player.health_component.died.connect(_on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(Scenes.pause_menu.instantiate())
		get_tree().root.set_input_as_handled()


func _on_player_died() -> void:
	var end_screen_instance := Scenes.end_screen.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
