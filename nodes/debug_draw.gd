extends Control
class_name DebugDraw

var shapes: Array[Geometry] = []


func _draw() -> void:
	if shapes.is_empty():
		push_warning("no shape to draw")
		return

	for geometry: Geometry in shapes:
		var line := geometry.shape as SegmentShape2D
		if line:
			draw_line(line.a, line.b, geometry.color, 2.0)


func _process(_delta) -> void:
	queue_redraw()


func push_shape(shape: Shape2D, color: Color) -> void:
	shapes.push_back(Geometry.new(shape, color))


func clear() -> void:
	shapes.clear()
