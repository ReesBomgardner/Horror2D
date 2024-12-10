extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player") and !GameManager.sprint_tutorial:
		DialogueManager.set_type("sprint")
		DialogueManager.emit_signal("update_dialogue")
		GameManager.sprint_tutorial = true
	pass # Replace with function body.
