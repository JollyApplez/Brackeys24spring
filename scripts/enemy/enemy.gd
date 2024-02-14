class_name Enemy
extends CharacterBody3D

var target
var is_staggered: bool = false

var SPEED = 3.0

@export var stats: Stats : set = set_enemy_stats
@export var staggered_time: float

@onready var navigation_agent_3d = $NavigationAgent3D


func _ready():
	target = get_tree().get_first_node_in_group("player")
	SPEED = stats.speed
	
	
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 5 * delta
	
	if !is_staggered and is_on_floor():
		if target:
			navigation_agent_3d.target_position = target.global_position
			var next_pos = navigation_agent_3d.get_next_path_position()
			var direction = position.direction_to(next_pos)
			#look_at(Vector3(target.global_position.x, position.y, target.global_position.z))
			_look_at_target_interpolated(0.06)
			
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _look_at_target_interpolated(weight:float) -> void:
	var xform := transform # your transform
	xform = xform.looking_at(target.global_position,Vector3.UP)
	transform = transform.interpolate_with(xform,weight)

func set_enemy_stats (value: Stats) -> void: 
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()
	
func update_stats() -> void:
		pass #Update UI here

func take_damage(damage: int, k: Knockback) -> void: 
	if stats.health <= 0: 
		return
		
	stats.take_damage(damage)
	staggered()
	knockback(k)
	
	if stats.health <= 0:
		death()
	print(stats.health)

func knockback(k: Knockback):
	velocity += (global_transform.origin - k.knockback_origin).normalized() * k.knockback_force / stats.knockback_resistance
	velocity.y += k.knockback_force / stats.knockback_resistance
	
func staggered():
	var t = Timer.new()
	add_child(t)
	t.start(staggered_time)
	
	is_staggered = true
	await t.timeout
	is_staggered = false

func death():
	queue_free()
