extends Node
class_name Main

@onready var player: Player = %Player


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("763b36"))

	player.health_component.died.connect(_on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(Screens.pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()


func _on_player_died() -> void:
	var end_screen_instance := Screens.end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
