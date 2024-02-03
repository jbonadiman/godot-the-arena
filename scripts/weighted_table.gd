class_name WeightedTable
extends Node

var items: Array[WeightedItem] = []
var weight_sum := 0


func add_item(item: Variant, weight: int) -> void:
	items.append(WeightedItem.new(item, weight))
	weight_sum += weight


func remove_item(item_to_remove: Variant) -> void:
	items = items.filter(
		func(weighted_item: WeightedItem):
			return weighted_item.value != item_to_remove)
	weight_sum = 0
	for item in items:
		weight_sum += item.weight


func pick_item(exclude: Array = []) -> Variant:
	var adjusted_items := items
	var adjusted_weight_sum := weight_sum
	if not exclude.is_empty():
		adjusted_items = []
		adjusted_weight_sum = 0

		for item in items:
			if item.value in exclude:
				continue
			adjusted_items.push_back(item)
			adjusted_weight_sum += item.weight

	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iter_sum := 0
	for item in adjusted_items:
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
