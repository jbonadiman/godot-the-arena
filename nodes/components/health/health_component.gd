@tool

class_name HealthComponent
extends Node2D

signal died
signal changed
signal decreased
signal increased

@export var max_health: float = 10
@export var show_by_default := false
@export_color_no_alpha var health_bar_color := Color("e84537")

@onready var progress_bar: StyledProgressBar = %ProgressBar

var current_health: float : set = _set_health


func _ready() -> void:
	changed.connect(_on_changed)

	current_health = max_health
	progress_bar.visible = show_by_default
	progress_bar.bar_color = health_bar_color

	_update_display()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if progress_bar:
			progress_bar.visible = show_by_default
			progress_bar.bar_color = health_bar_color


func _set_health(value: float) -> void:
	current_health = clampf(value, 0, max_health)

	progress_bar.visible = true
	if current_health == max_health:
		progress_bar.visible = show_by_default
	changed.emit()


func heal(amount: float) -> void:
	current_health += amount
	increased.emit()


func damage(amount: float) -> void:
	current_health -= amount
	decreased.emit()

	if current_health == 0:
		die.call_deferred()


func _update_display() -> void:
	progress_bar.value = _get_health_percentage()


func _get_health_percentage() -> float:
	return clampf(current_health / max_health, 0, 1)


func die() -> void:
	died.emit()
	owner.queue_free()


func _on_changed() -> void:
	_update_display()
