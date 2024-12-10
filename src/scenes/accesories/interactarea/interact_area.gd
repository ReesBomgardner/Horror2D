extends Area2D

@onready var anim = $AnimationPlayer
@export_enum("Hide", "Books", "Clock", "Drawer", "Mirror", "Fridge", "Skull") var type = "Books"

var entered = false
var interacted = false

func _input(event):
	if Input.is_action_just_pressed("hide") and entered and type == "Hide":
		interacted = !interacted
		GameManager.emit_signal("player_hides")
		show_texture(interacted)
		if DialogueManager.dialogue_index == 5:
			DialogueManager.empty_dialogue()
			await get_tree().create_timer(1).timeout
			DialogueManager.set_index(6,-1)
			DialogueManager.next_script()
			#GameManager.tutorial_ended = true
	
	if Input.is_action_just_pressed("interact") and entered:
		if GameManager.tutorial_ended:
			DialogueManager.set_type(type)
			DialogueManager.emit_signal("update_dialogue")
			return
		
		match type:
			"Clock":
				if DialogueManager.dialogue_index == 2:
					DialogueManager.empty_dialogue()
					await get_tree().create_timer(1).timeout
					DialogueManager.set_index(3,-1)
					DialogueManager.next_script()
					pass
			"Drawer":
				if DialogueManager.dialogue_index <= 3:
					DialogueManager.empty_dialogue()
					await get_tree().create_timer(1).timeout
					DialogueManager.set_index(4,-1)
					DialogueManager.next_script()
					
					GameManager.add_item({
						"texture_path": "res://src/assets/icons/Icon14_33.png",
						"amount": 1,
						"type": "Flashlight",
						"variant": "Flashlight",
						"region": Rect2(1, 1, 30, 30)
					})
				pass


func show_texture(condition: bool):
	if condition: anim.play("intro") 
	else: anim.play_backwards("intro")
	pass

func get_texture_region():
	var region = Rect2(33,17,14,13)
	var texture = null
	match type:
		"Hide": 
			region = Rect2(145, 97, 14, 13)
			texture = Rect2(145, 145, 14, 13)
		
	
	return { "region": region, "texture": texture }
	pass

func _on_area_entered(area):
	if area.is_in_group("player"):
		var body = area.get_parent()
		entered = true
		body.interact(true, get_texture_region().region)
		if type == "Hide": body.can_hide = true
	pass # Replace with function body.


func _on_area_exited(area):
	if area.is_in_group("player"):
		var body = area.get_parent()
		entered = false
		body.interact(false, get_texture_region().region)
		if type == "Hide": body.can_hide = false
	pass # Replace with function body.
