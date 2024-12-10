extends Node2D
@export_enum("Living Room", "Lobby", "Storage", "Library", "Bath Room", "Main Room") var room_name = "Living Room"
@onready var positions = $Positions
@onready var doors = $Doors
@onready var current_scene = get_tree().root.get_child(5).name
@export var enemy_default_spawn_index = 0
@onready var gui = $GUI

var player_scene = preload("res://src/scenes/character/character.tscn")
var enemy_scene = preload("res://src/scenes/enemy/enemy.tscn")
var gameover_scene = preload("res://src/scenes/menus/gameover_menu/gameover.tscn")

var enemy_spawned = false
var enemy = null

func _ready():
	randomize()
	spawn_player()
	spawn_and_navigate_enemy()
	EnemyNavigationManager.connect("spawn_enemy", spawn_enemy_to_room)
	EnemyNavigationManager.connect("spawn_chase_enemy", spawn_chase_enemy)
	GameManager.connect("game_ended", gameover)
	pass

func spawn_player():
	var player = player_scene.instantiate()
	var positions = positions.get_children()
	var spawn_index = GameManager.spawn_index
	var pos = positions[spawn_index].position
	player.position = pos
	
	if EnemyNavigationManager.chasing_player:
		EnemyNavigationManager.player_target = player
	add_child(player)
	pass

func spawn_and_navigate_enemy():
	if EnemyNavigationManager.has_spawned_enemy and !enemy:
		spawn_enemy()
		pass

	if EnemyNavigationManager.chasing_player: return
	if EnemyNavigationManager.selectedRoom and current_scene == EnemyNavigationManager.selectedRoom.name:
		if EnemyNavigationManager.movement_timer.time_left < EnemyNavigationManager.navigation_distance/2.5 and !enemy:
			spawn_enemy(enemy_default_spawn_index)
	pass

func spawn_enemy_to_room(room):
	if current_scene == room.name:
		if !enemy: spawn_enemy()
	pass

func spawn_enemy(index = null):
	var _enemy = enemy_scene.instantiate()
	var spawn_index = GameManager.enemy_spawn_index
	if index: spawn_index = index
	var pos = positions.get_child(spawn_index)
	if EnemyNavigationManager.player_target: _enemy.player_target = EnemyNavigationManager.player_target

	if pos: 
		_enemy.position = pos.position
		enemy = _enemy
		add_child(_enemy)
	
	pass

func spawn_chase_enemy():
	if !enemy: 
		spawn_enemy()
		EnemyNavigationManager.has_spawned_enemy = true
	pass
	
func spawn_gameover():
	var scene = gameover_scene.instantiate()
	gui.add_child(scene)
	pass

func gameover():
	spawn_gameover()
	if get_tree(): get_tree().paused = true
	pass
