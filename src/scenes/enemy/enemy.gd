extends CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D
@onready var target_positions = $"../WanderPositions"
@onready var doors = $"../Doors"
@onready var take_hit_timer = $TakeHitTimer
@onready var sprite = $Sprite2D

var speed = 220
var fast_speed = 220
var slow_speed = 100
var damage = 1
var can_navigate = false 

var target = null
var player_target = null
var can_exit_room = false
var can_take_damage = false

var normal_color = "ffffff"
var hurt_color = "ff0000"

func _ready():
	EnemyNavigationManager.connect("update_target", _update_target)
	EnemyNavigationManager.connect("stop_chasing_player", _stop_chasing_player)


func _physics_process(delta):
	if !can_navigate: return
	
	follow_player()
	if navigation_agent.is_navigation_finished(): return
	
	var current_agent_pos = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	
	velocity = current_agent_pos.direction_to(next_path_position) * speed
	move_and_slide()

func move_to_target_pos():
	if EnemyNavigationManager.chasing_player: return 
	if player_target: return
	
	randomize()
	var target_index = randi()%target_positions.get_child_count()
	var _target = target_positions.get_child(target_index)
	target = _target
	
	#await get_tree().create_timer(0.1).timeout
	#position = $NavigationAgent2D.get_current_navigation_path()[2]
	#print($NavigationAgent2D.get_current_navigation_path(), "path")
	pass

func move_to_door():
	var door_index = EnemyNavigationManager.selectedRoom.lobby_index
	target = doors.get_child(door_index)
	pass

func _update_target(room):
	if EnemyNavigationManager.chasing_player: return 
	var current_scene = get_tree().root.get_child(5).name
	
	if current_scene == room.name:
		move_to_target_pos()
	else:
		move_to_door()
		can_exit_room = true
		pass
	pass

func follow_player():
	if player_target:
		navigation_agent.target_position = player_target.global_position
	else:
		if target: navigation_agent.target_position = target.global_position
	pass

func _stop_chasing_player():
	player_target = null
	GameManager.emit_signal("end_continuous_shake")
	GameManager.emit_signal("change_track", false)
	pass

func start_slow_down():
	speed = slow_speed
	
	if !can_take_damage: 
		can_take_damage = true
		take_hit_timer.start()

func end_slow_down():
	speed = fast_speed
	can_take_damage = false
	take_hit_timer.stop()
	
func take_hit():
	var tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "modulate", Color(hurt_color), 0.05)
	await tween.finished
	
	tween.stop()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "modulate", Color(normal_color), 0.05)
	tween.play()
	pass

func _on_navigation_agent_2d_navigation_finished():
	EnemyNavigationManager.emit_signal("chase_player")
	target = null
	pass # Replace with function body.


func _on_timer_timeout():
	can_navigate = true
	move_to_target_pos()
	pass # Replace with function body.


func _on_detect_area_body_entered(body):
	if body.is_in_group("player"):
		if body.hiding: return
		player_target = body
		EnemyNavigationManager.chasing_player = true
		GameManager.emit_signal("start_continuous_shake")
		GameManager.emit_signal("change_track", true)
		pass
	pass # Replace with function body.


func _on_hit_area_body_entered(body):
	if body.is_in_group("player"):
		if body.hiding: return
		body.start_take_damage(damage)
		pass
	pass # Replace with function body.


func _on_hit_area_body_exited(body):
	if body.is_in_group("player"):
		if body.hiding: return
		body.stop_take_damage()
		pass
	pass # Replace with function body.


func _on_take_hit_timer_timeout():
	take_hit()
	pass # Replace with function body.
