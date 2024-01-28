extends Control
class_name DebugDraw

const STROKE_WIDTH := 2.0

var shapes: Array[Geometry] = []


func _draw() -> void:
	for geometry: Geometry in shapes:
		_draw_line(geometry as Line)
		_draw_arrow(geometry as Arrow)


func _draw_line(line: Line) -> void:
	if not line:
		return
	draw_line(line.a, line.b, line.color, STROKE_WIDTH)


func _draw_arrow(arrow: Arrow) -> void:
	if not arrow:
		return
	draw_line(arrow.from, arrow.to, arrow.color, STROKE_WIDTH)

	var first_point = arrow.to * 1.2

	var points: PackedVector2Array = [
		first_point,
		first_point.rotated(deg_to_rad(165)),
		first_point.rotated(deg_to_rad(200)),
		#Vector2(arrow.to.x + 2.5, arrow.to.y),
		#Vector2(arrow.to.x - 2.5, arrow.to.y),
	]

	draw_polygon(points, [arrow.color])


func _process(_delta) -> void:
	queue_redraw()


func push_geometry(geometry: Geometry) -> void:
	shapes.push_back(geometry)


func clear() -> void:
	shapes.clear()


class Geometry:
	extends Control

	var color: Color


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

