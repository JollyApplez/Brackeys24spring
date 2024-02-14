extends Node

var current_level: int = 1 : set = set_current_level
func set_current_level(value: int):
	if current_level + 1 == value:
		current_level = value
		SignalHub.level_changed.emit(current_level)

var high_score
