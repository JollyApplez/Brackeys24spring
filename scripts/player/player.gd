extends CharacterBody3D
class_name Player

const SPEED = 8.0
const JUMP_VELOCITY = 4.5

@onready var movement_anim = $MovementAnim
@onready var weapon_anim = $WeaponSocket/WeaponAnim
@onready var weapon_socket = $WeaponSocket

@export var sensitivity: float = 1.5
@export var weapon: Weapon : set = set_weapon
@export var stats: Stats: set = set_character_stats
@export var starter_weapon: PackedScene

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var w = starter_weapon.instantiate()
	weapon = w
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensitivity))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		movement_anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		movement_anim.play("RESET")

	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		if !weapon_anim.is_playing():
			weapon_anim.play("MeleeAttackSword")
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func set_weapon_hurtbox(is_active: bool): 
	weapon.hurtbox.monitoring = is_active

func set_weapon(value: Weapon):
	if weapon:
		weapon.queue_free()
	weapon = value
	if weapon_socket:
		weapon_socket.add_child(weapon)
		weapon.global_transform = weapon_socket.global_transform

func set_character_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()

func update_player() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	update_stats()
	
func update_stats() -> void:
		pass
