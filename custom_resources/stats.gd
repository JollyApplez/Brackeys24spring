extends Resource
class_name Stats

signal stats_changed

@export var max_health := 1
@export var speed: int
@export var knockback_resistance: float = 1

var health: int : set = set_health

func set_health(value : int):
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func take_damage(damage : int):
	if damage <= 0: 
		return
	
	var initial_damage = damage
	damage = clampi(damage, 0, damage)
	self.health -= damage
	
func heal(amount : int):
	self.health  += amount

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance
