extends Control

@export var outro = false
@export var world: String
@onready var label = $CenterContainer/Label

func _ready():
	DialogueManager.connect("update_dialogue", read)
	DialogueManager.connect("next_scene", next_scene)

	reset_read()
	
	await get_tree().create_timer(1).timeout
	read()
	pass

func reset_read():
	DialogueManager.reset_read(label)

func read():
	await DialogueManager.read(label)
	await get_tree().create_timer(2).timeout
	DialogueManager.next_script()

func next_scene():
	#if outro: DialogueManager.set_index(0,0)
	Transition.emit_signal("navigate", { 
		"scene_path": world, 
		"spawn_index": 0,
		"enemy_spawn_index": 1
	})

func _input(event):
	if Input.is_action_just_pressed("skip_dialogue"):
		DialogueManager.skip_dialogue(label)
