extends Node

@onready var enemy_difficulty_time: Timer = %EnemyDifficultyTimer
@onready var health_regen_timer: Timer = %HealthRegenTimer
@onready var end_game_timer: Timer = %EndGameTimer

var arena_difficulty: int
var elapsed_time: float : get = _get_elapsed_time


func _ready() -> void:
	enemy_difficulty_time.timeout.connect(_on_enemy_difficulty_timeout)
	health_regen_timer.timeout.connect(_on_health_regen_timeout)
	end_game_timer.timeout.connect(_on_end_game_timeout)


func _get_elapsed_time() -> float:
	return end_game_timer.wait_time - end_game_timer.time_left


func start() -> void:
	enemy_difficulty_time.start()
	health_regen_timer.start()
	end_game_timer.start()
	arena_difficulty = 0


func _on_end_game_timeout() -> void:
	var instance := Scenes.end_screen.instantiate() as EndScreen
	add_child(instance)
	instance.play_jingle()


func _on_enemy_difficulty_timeout() -> void:
	arena_difficulty += 1
	GameEvents.arena_difficulty_increased.emit(arena_difficulty)


func _on_health_regen_timeout() -> void:
	GameEvents.health_regen_tick.emit()

