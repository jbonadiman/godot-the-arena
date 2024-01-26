@tool
extends ProgressBar
class_name StyledProgressBar

const BORDER_COLOR := Color("3f2631")

@onready var bar_color: Color
@onready var style_box := StyleBoxFlat.new()


func _ready() -> void:
	add_theme_stylebox_override("fill", style_box)

	style_box.set_border_width_all(2)
	style_box.border_color = BORDER_COLOR
	#style_box.bg_color = bar_color


func _process(_delta: float) -> void:
	style_box.bg_color = bar_color

