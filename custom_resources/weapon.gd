extends Node3D
class_name Weapon

enum Weapon_Type {Sword, Lance, Spear}

@export_group("Weapon Attributes")
@export var id: String
@export var type: Weapon_Type
@export var damage: int
@export var knockback_force: int
@export var attack_speed: float
@export var stamina_cost: float

@export_group("Weapon Nodes")
@export var visuals: Node3D
@export var hurtbox: Hurtbox
@export_multiline var tooltip_text: String
