extends Control

@onready var anim = $AnimationPlayer
@onready var sound = $AudioStreamPlayer2D
signal navigate(navigation)

var can_transition = true

func _ready():
	GameManager.connect("game_started", _game_started)
	GameManager.connect("game_ended", _game_ended)

func _game_started():
	can_transition = true
	pass

func _game_ended():
	can_transition = false
	anim.stop()
	anim.play("RESET")
	pass

func _on_navigate(navigation):
	if !can_transition: return
	GameManager.spawn_index = navigation.spawn_index
	GameManager.enemy_spawn_index = navigation.enemy_spawn_index

	anim.play("intro")
	await anim.animation_finished
	if !can_transition: return
	
	
	if !GameManager.game_completed and DialogueManager.dialogue_index <= 0: 
		get_tree().change_scene_to_file("res://src/scenes/dialogues/story_intro/story_intro.tscn")
		return
	if GameManager.game_completed and !GameManager.move_back_to_main_menu:
		DialogueManager.empty_dialogue()
		await get_tree().create_timer(1).timeout
		DialogueManager.set_index(7,-1)
		DialogueManager.next_script()
		get_tree().change_scene_to_file("res://src/scenes/dialogues/story_outro/story_outro.tscn")
		GameManager.move_back_to_main_menu = true
		return

	
	get_tree().change_scene_to_file(navigation.scene_path)
	anim.play_backwards("intro")
	pass # Replace with function body.
