extends Area2D

@export_enum("Red Key", "Blue Key", "Green Key", "Yellow Key") var keyToUnlock = "Red Key"
@export var scene_path: String
@export var use_interact = false
@export var spawn_index = 0
@onready var current_scene = get_tree().root.get_child(5)
@onready var interface = $"../../GUI/Interface" 

var entered = false

func _ready():
	pass

func navigate():
	if keyToUnlock == "Yellow Key":
		GameManager.game_completed = true
		DialogueManager.set_index(7, -1)
	
	Transition.emit_signal("navigate", { 
		"scene_path": scene_path, 
		"spawn_index": spawn_index,
		"enemy_spawn_index": spawn_index
		})
	
	if EnemyNavigationManager.chasing_player:
		var enemy = current_scene.enemy
		EnemyNavigationManager.cal_chase_time(enemy, self)
	
	if use_interact: GameManager.emit_signal("play_door_sound")
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		entered = true
		if !use_interact: navigate()
		else: body.interact(true)
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("player"):
		entered = false
		if use_interact: body.interact(false)
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("interact") and entered:
		if validate_entry(): 
			navigate()
			if !GameManager.tutorial_ended:
				GameManager.start_game()
				GameManager.tutorial_ended = true
		else: 
			if GameManager.tutorial_ended:
				DialogueManager.set_type("Door")
				DialogueManager.emit_signal("update_dialogue")
			GameManager.emit_signal("player_locked_door_sound")


func _on_area_entered(area):
	if area.is_in_group("enemy") and area.get_parent().can_exit_room:
		area.get_parent().queue_free()
	pass # Replace with function body.

func validate_entry():
	if GameManager.keys.has(keyToUnlock): return true
	for index in GameManager.inventory.size():
		if (GameManager.inventory[index].variant == keyToUnlock): 
			GameManager.inventory.remove_at(index)
			interface.inventory.get_child(index).get_child(0).texture = null
			GameManager.keys.append(keyToUnlock)
			return true
		pass
	
	return false
