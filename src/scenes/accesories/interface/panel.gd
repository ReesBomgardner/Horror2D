extends Button

@export_enum("1", "2", "3", "4") var type = "1"

func _ready():
	connect("pressed",  handle_pressed)

func get_key():
	var key = null
	match type:
		"1": key = KEY_1
		"2": key = KEY_2
		"3": key = KEY_3
		"4": key = KEY_4
	
	return key

func _input(event):
	if Input.is_key_label_pressed(get_key()):
		handle_pressed()
		pass
	
	pass

func set_values(index):
	var type = GameManager.inventory[index].type
	match type:
		"Flashlight": GameManager.flash_amount += GameManager.max_flash
	pass

func handle_pressed():
	if get_child(0).texture == null: return
	var index = get_index()
	
	if GameManager.inventory[index].type.find("Key") != -1: return
	set_values(index)
	
	get_child(0).texture = null
	GameManager.inventory.remove_at(index)
	pass
