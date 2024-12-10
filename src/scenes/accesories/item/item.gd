extends Area2D
@export_enum("Flashlight", "Red Key", "Blue Key", "Green Key", "Yellow Key") var type = "Flashlight"
@onready var sprite = $Sprite2D
var entered = false

func _ready():
	set_item_texture()
	check_if_item_can_exist()

func check_if_item_can_exist():
	if GameManager.check_if_item_exists_db(name):
		queue_free()

func _input(event):
	if Input.is_action_just_pressed("interact") and entered:
		pick_up_item()
		queue_free()

func set_item_texture():
	var texture_path = get_item().texture_path
	var region = get_item().region
	if texture_path: sprite.texture = load(texture_path)
	if region: sprite.region_rect = region
	pass

func get_item():
	var texture_path = null
	var region = null
	
	match type:
		"Flashlight": 
			texture_path = "res://src/assets/icons/Icon14_33.png"
			region = Rect2(1, 1, 30, 30)
		"Red Key": 
			texture_path = "res://src/assets/icons/KeyIcons.png" 
			region = Rect2(2, 0, 28, 31)
		"Blue Key": 
			texture_path = "res://src/assets/icons/KeyIcons.png" 
			region = Rect2(33, 0, 29, 31)
		"Green Key": 
			texture_path = "res://src/assets/icons/KeyIcons.png" 
			region = Rect2(65, 1, 28, 30)
		"Yellow Key": 
			texture_path = "res://src/assets/icons/KeyIcons.png" 
			region = Rect2(97, 1, 29, 28)
		
	return { "texture_path": texture_path, "region": region }

func pick_up_item():
	var texture_path = get_item().texture_path
	var region = get_item().region
	
	match type:
		"Red Key":
			if DialogueManager.dialogue_index <= 6:
				DialogueManager.empty_dialogue()
				#await get_tree().create_timer(2).timeout
				DialogueManager.set_index(5,-1)
				DialogueManager.next_script()
				
				GameManager.start_game()
				#GameManager.tutorial_ended = true
				EnemyNavigationManager.selectedRoom =  {
					"name": "LivingRoom",
					"lobby_index": 0,
				}
				pass
	
	GameManager.add_item({
		"texture_path": texture_path,
		"amount": 1,
		"type": type,
		"variant": type,
		"region": region
	})
	GameManager.add_used_item(name)
	pass

func _on_area_entered(area):
	if area.is_in_group("player"):
		var body = area.get_parent()
		entered = true
		body.interact(true)
	pass # Replace with function body.


func _on_area_exited(area):
	if area.is_in_group("player"):
		var body = area.get_parent()
		entered = false
		body.interact(false)
	pass # Replace with function body.
