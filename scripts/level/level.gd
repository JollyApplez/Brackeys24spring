extends Node3D
class_name Level

var enemy_amount: int
var spawn_time: float
var enemy_types: Array = []
var arena_map
var current_arena: ArenaMap
var survial_time: float
var player_weapon: Weapon
var enemies_alive: int
var initialized: bool

@onready var navigation_region_3d = $NavigationRegion3D
@onready var survival_timer = $SurvivalTimer
@onready var enemy_spawn_timer = $EnemySpawnTimer

func _ready():
	print("Ready Level")
func _process(delta):
	
	if initialized: 
		if enemies_alive < enemy_amount and enemy_spawn_timer.is_stopped():
			enemy_spawn_timer.start()



func init(levelmanager: LevelManager):
	process_mode = PROCESS_MODE_INHERIT
	print(arena_map)
	current_arena = arena_map.instantiate()
	navigation_region_3d.add_child(current_arena)
	current_arena.global_position = levelmanager.global_position
	navigation_region_3d.bake_navigation_mesh()
	survival_timer.wait_time = survial_time
	survival_timer.start()
	enemy_spawn_timer.wait_time = spawn_time

	initialized = true
func player_spawn():
	pass

func enemy_spawn():
	enemies_alive += 1
	var e = enemy_types.pick_random()
	e = e.instantiate()
	add_child(e)
	e.global_position = current_arena.spawn_points.pick_random().global_position

func _on_survival_timer_timeout():
	#Survived
	pass


func _on_enemy_spawn_timer_timeout():
	enemy_spawn()
