extends Node
class_name Geometry

var color: Color
var shape: Shape2D


func _init(new_shape: Shape2D, new_color: Color) -> void:
	shape = new_shape
	color = new_color
