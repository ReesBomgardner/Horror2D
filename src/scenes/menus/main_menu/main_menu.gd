extends Control

@export var world: String
@onready var settings_menu = $GUI/SettingsMenu
@onready var time_played_label = $TimePlayedLabel

func _ready():
	GameManager.set_gui(false)
	reset()
	pass

func _on_play_button_pressed():
	if GameManager.tutorial_ended: GameManager.start_game()
	Transition.can_transition = true
	Transition.emit_signal("navigate", { 
		"scene_path": world, 
		"spawn_index": 0,
		"enemy_spawn_index": 1
	})
	pass # Replace with function body.

func reset():
	EnemyNavigationManager.chasing_player = false
	EnemyNavigationManager.has_spawned_enemy = false
	EnemyNavigationManager.can_spawn_enemy = true
	EnemyNavigationManager.player_target = null
	EnemyNavigationManager.selectedRoom = {}
	GameManager.health = GameManager.max_health
	GameManager.emit_signal("change_track", false)
	#GameManager.inventory = []
	#DialogueManager.set_index(1,0)
	time_played_label.text = "Time Played: " + str(GameManager.time_to_minutes_seconds(GameManager.time_played))
	pass

func _on_options_button_pressed():
	settings_menu.show()
	pass # Replace with function body.
