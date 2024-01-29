extends CharacterBody2D
class_name BasicEnemy

@onready var health_component : HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var visuals: Node2D = $Visuals


func _process(_delta: float) -> void:
	velocity_component.accelerate_towards_player()
	velocity_component.move(self)

	var move_sign: int = sign(velocity.x)
	visuals.scale.x = -move_sign if move_sign else 1
