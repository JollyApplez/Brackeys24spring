extends Area3D

@export var host: CharacterBody3D

func take_damage(damage: int, knockback: Knockback): 
	host.take_damage(damage, knockback)
