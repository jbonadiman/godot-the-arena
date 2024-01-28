class_name DeathComponent
extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D

@onready var particles_2d: GPUParticles2D = $GPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var entities_layer: Node2D


func _ready() -> void:
	particles_2d.texture = sprite.texture
	health_component.died.connect(_on_died)
	entities_layer = get_tree().get_first_node_in_group("entities_layer")


func _on_died() -> void:
	if not owner or not owner is Node2D:
		push_error("owner is null or not Node2D")
		return

	var spawn_position: Vector2 = owner.global_position
	get_parent().remove_child(self)

	entities_layer.add_child(self)
	global_position = spawn_position
	animation_player.play("default")
