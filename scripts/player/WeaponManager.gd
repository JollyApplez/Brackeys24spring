class_name WeaponManager
extends Node3D

@export var weapon: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func damage(target):
	target.take_damage()
