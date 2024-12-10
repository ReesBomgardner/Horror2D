extends Control


func _ready():
	GameManager.show_gui.connect(_set_visibility)
	pass

func _set_visibility(value):
	visible = value
	pass
