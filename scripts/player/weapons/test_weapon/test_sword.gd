extends Weapon


func _ready():
	hurtbox.damage = damage
	hurtbox.knockback_force = knockback_force
