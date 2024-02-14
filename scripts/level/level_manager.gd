extends Node3D
class_name LevelManager

var level_scene = preload("res://scripts/level/Level.tscn")

@export var levels: Array[DifficultyLevel]
@export var weapons: Array[PackedScene]
@export var enemies: Array[PackedScene]
@export var arenas_dict = {}
@export var survival_time: Array[int]

var current_levelmap: Level

@onready var navigation_region_3d = $NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalHub.level_init.connect(level_init)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func level_init () -> void: 
	var l = level_scene.instantiate()
	add_child(l)
	current_levelmap = l 
	var difficulty = GameManager.current_level - 1
	difficulty = levels[difficulty]
	l.spawn_time = randi_range(difficulty.min_spawn_time, difficulty.max_spawn_time)
	l.enemy_amount = randi_range(difficulty.min_enemy_amount, difficulty.max_enemy_amount)
	for i in difficulty.type_amount:
		print("loop")
		var e = enemies.pick_random()
		if !l.enemy_types.has(e):
			l.enemy_types.append(e)
	var maps: Array = arenas_dict.keys()
	
	var map = maps.pick_random()
	l.arena_map = arenas_dict.get(map)
	l.survial_time = survival_time.pick_random()
	#last thing that happens on level_init
	
	l.init(self)
	
