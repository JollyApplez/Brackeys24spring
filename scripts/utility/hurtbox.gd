extends Area3D
class_name Hurtbox

@export var damage: int
@export var knockback_force: int

func _on_area_entered(area):
	if area.is_in_group("hitbox"):
		if area.has_method("take_damage"):
			var k = Knockback.new()
			k.knockback_force = knockback_force
			k.knockback_origin = global_transform.origin
			area.take_damage(damage, k)
			print("hit")

