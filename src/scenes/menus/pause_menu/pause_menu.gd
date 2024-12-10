extends Control

func _ready():
	GameManager.show_gui.connect(_set_visibility)
	pass

func _set_visibility(value):
	visible = value
	pass


func _input(event):
	if Input.is_action_just_pressed("escape"):
		GameManager.set_gui(!GameManager.show_gui_value)
		get_tree().paused = !get_tree().paused
	pass
