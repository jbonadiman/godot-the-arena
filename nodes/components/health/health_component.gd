@tool

extends Node2D
class_name HealthComponent

signal died
signal changed

@export var max_health: float = 10
@export var show_by_default := false
@export_color_no_alpha var health_bar_color := Color("e84537")

@onready var progress_bar: StyledProgressBar = %ProgressBar

var current_health


func _ready() -> void:
	current_health = max_health
	progress_bar.visible = show_by_default
	progress_bar.bar_color = health_bar_color

	update_display()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if progress_bar:
			progress_bar.visible = show_by_default
			progress_bar.bar_color = health_bar_color


func damage(amount: float) -> void:
	progress_bar.visible = true
	current_health = max(current_health - amount, 0)
	changed.emit()

	if current_health == 0:
		Callable(die).call_deferred()


func update_display() -> void:
	progress_bar.value = get_health_percentage()


func get_health_percentage() -> float:
	return clampf(current_health / max_health, 0, 1)


func die() -> void:
	died.emit()
	owner.queue_free()


func _on_changed() -> void:
	update_display()
