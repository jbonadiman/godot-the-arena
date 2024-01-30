class_name DebugDraw
extends Control

const STROKE_WIDTH := 2.0

var shapes: Array[Geometry] = []


func _draw() -> void:
	for geometry: Geometry in shapes:
		geometry._draw(self, STROKE_WIDTH)


func _process(_delta) -> void:
	queue_redraw()


func push_geometry(geometry: Geometry) -> void:
	shapes.push_back(geometry)


func clear() -> void:
	shapes.clear()


class Geometry:
	var color: Color

	func _draw(_control: Control, _stroke_width: float = 2.0) -> void:
		assert(false, "_draw not implemented")


class Line:
	extends Geometry

	var a: Vector2
	var b: Vector2

	func _init(
		point_a := Vector2.ZERO,
		point_b := Vector2.ZERO,
		init_color := Color.RED):

		color = init_color
		a = point_a
		b = point_b


	func _draw(control: Control, stroke_width: float = 2.0) -> void:
		control.draw_line(a, b, color, stroke_width)


class Arrow:
	extends Geometry

	var from: Vector2
	var to: Vector2

	func _init(
		_from := Vector2.ZERO,
		_to := Vector2.ZERO,
		_color := Color.BLUE) -> void:

		color = _color
		from = _from
		to = _to

	func _draw(control: Control, stroke_width: float = 2.0) -> void:
		control.draw_line(from, to, color, stroke_width)
		# TODO: draw triangle at the tip?
		var first_point = to * 1.2

		var points: PackedVector2Array = [
			first_point,
			first_point.rotated(deg_to_rad(165)),
			first_point.rotated(deg_to_rad(200)),
			#Vector2(arrow.to.x + 2.5, arrow.to.y),
			#Vector2(arrow.to.x - 2.5, arrow.to.y),
		]

		control.draw_polygon(points, [color])

