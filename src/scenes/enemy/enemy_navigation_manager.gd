extends Node2D

@onready var movement_timer = $MovementTimer
@onready var reset_timer = $Timer
@onready var chase_timer = $ChaseTimer

signal update_target(target)
signal chase_player
signal spawn_enemy(target)
signal spawn_chase_enemy
signal stop_chasing_player

var navigation_distance = 8
var max_navigation_distance = 8

var rooms = [
	{
		"name": "LivingRoom",
		"lobby_index": 0,
	},
	{
		"name": "Library",
		"lobby_index": 0,
	},
	{
		"name": "Bathroom",
		"lobby_index": 0,
	},
	{
		"name": "Storage",
		"lobby_index": 0,
	},
	{
		"name": "SecondLivingRoom",
		"lobby_index": 0,
	}
]

var selectedRoom = {}
var can_spawn_enemy = true
var last_index = 0;

#CHASING PLAYER
var chasing_player = false
var chase_time = 0
var player_target = null

var has_spawned_enemy = false

func _ready():
	GameManager.connect("game_started", _start)
	connect("stop_chasing_player", _stop_chasing_player)

func _start():
	reset_timer.start()
	pass

func _process(delta): 
	if chasing_player: return
	
	if (movement_timer.time_left > 0 and movement_timer.time_left < navigation_distance/2.5) and can_spawn_enemy:
		if selectedRoom: emit_signal("spawn_enemy", selectedRoom)
		can_spawn_enemy = false
	pass

func chose_target():
	randomize()
	if DialogueManager.dialogue_index <= 5:
		emit_signal("update_target", {
		"name": "LivingRoom",
		"lobby_index": 0,
		})
		return
	var room_index = randi()%rooms.size()
	var room = rooms[room_index]
	selectedRoom = room
	emit_signal("update_target", room)
	pass

func get_wait_time():
	return round(navigation_distance - movement_timer.time_left)
	pass

func cal_chase_time(enemy, player):
	if chase_timer.time_left > 0.1: return
	
	var enemy_pos = Vector2.ZERO
	if enemy: enemy_pos = enemy.global_position
	var player_pos = player.global_position
	player_target = player
	
	var pos = enemy_pos.distance_to(player_pos)
	var _chase_timer = pos/200
	
	var chase_timer_value = clamp(_chase_timer,1,2)
	chase_timer.start(chase_timer_value)
	has_spawned_enemy = false
	pass

func _stop_chasing_player():
	chasing_player = false
	player_target = null
	has_spawned_enemy = false
	pass


func _on_timer_timeout():
	if chasing_player: return
	
	if selectedRoom: last_index = selectedRoom.lobby_index
	chose_target()
	if !GameManager.tutorial_ended: navigation_distance = 4
	else: navigation_distance = max_navigation_distance
	movement_timer.start(navigation_distance)
	pass # Replace with function body.


func _on_movement_timer_timeout():
	if chasing_player: return
	
	reset_timer.start()
	can_spawn_enemy = true
	pass # Replace with function body.


func _on_chase_player():
	if chasing_player: return
	
	reset_timer.start()
	can_spawn_enemy = false
	movement_timer.paused
	pass # Replace with function body.


func _on_chase_timer_timeout():
	emit_signal("spawn_chase_enemy")
	pass # Replace with function body.
