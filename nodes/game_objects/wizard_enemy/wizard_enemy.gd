class_name WizardEnemy
extends CharacterBody2D

@onready var velocity_component: VelocityComponent = %VelocityComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var visuals: Node2D = %Visuals
@onready var hurt_box_component: HurtBoxComponent = %HurtBoxComponent
@onready var audio_player: RandomStreamPlayer2DComponent = \
	%HitRandomAudioPlayerComponent

var is_moving := false : set = _set_is_moving


func _ready() -> void:
	hurt_box_component.hit.connect(_on_hit)


func _process(_delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_towards_player()
	else:
		velocity_component.decelerate()

	velocity_component.move(self)

	var move_sign: int = sign(velocity.x)
	visuals.scale.x = move_sign if move_sign else 1


func _set_is_moving(value: bool):
	is_moving = value


func _on_hit() -> void:
	audio_player.play_random()
