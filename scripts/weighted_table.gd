class_name WeightedTable
extends Node

var items: Array[WeightedItem] = []
var weight_sum := 0


func add_item(item: Variant, weight: int) -> void:
	items.append(WeightedItem.new(item, weight))
	weight_sum += weight


func pick_item() -> Variant:
	var chosen_weight = randi_range(1, weight_sum)
	var iter_sum := 0
	for item in items:
		iter_sum += item.weight
		if chosen_weight <= iter_sum:
			return item.value
	return items.back().value


class WeightedItem:
	var value: Variant
	var weight: int

	func _init(init_value: Variant, init_weight: int):
		value = init_value
		weight = init_weight
