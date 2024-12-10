extends Label

func _process(delta):
	text = "Health: " + str(GameManager.health)
	pass
