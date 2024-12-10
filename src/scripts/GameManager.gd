extends Node

signal show_gui(show_val)
signal game_started
signal game_ended
signal player_hides
signal update_inventory
signal enable_player_movement
signal player_bleeds
signal shake_screen(intensity, duration)
signal start_continuous_shake
signal end_continuous_shake
signal play_door_sound
signal change_track(value)
signal player_locked_door_sound

var show_gui_value = false
var spawn_index = 0 #player spawn index
var enemy_spawn_index = 0
var flashlight_active = false

var health = 5
var max_health = 5

var time_played = 0.0

var can_cal_time_played = false

#PLAYER
var sprint_amount = 5
var max_sprint = 5
var flash_amount = 0
var max_flash = 10

var tutorial_ended = false
var game_completed = false
var move_back_to_main_menu = false
var sprint_tutorial = false

var inventory = []
var used_items = []
var keys = []

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	pass

func _process(delta):
	if can_cal_time_played: time_played += delta
	pass

func _input(event):
	if Input.is_action_just_pressed("escape"):
		emit_signal("show_gui", show_gui_value)
	pass

func set_gui(value):
	show_gui_value = value
	pass

func start_game():
	can_cal_time_played = true
	emit_signal("game_started")
	pass

func add_item(item_dict):
	inventory.append(item_dict)
	emit_signal("update_inventory")

func check_if_item_exists_db(_name):
	if used_items.has(_name): return true
	return false

func add_used_item(_name):
	used_items.append(_name)

func time_to_minutes_seconds(total_seconds: int) -> String:
	var minutes = int(total_seconds / 60)
	var seconds = total_seconds % 60
	return str(minutes) + ":" + str("%02d" % seconds)
