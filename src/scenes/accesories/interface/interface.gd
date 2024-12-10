extends Control

@onready var health_label = $"LevelBox/Panel/MarginContainer/HBoxContainer/Stats/1/Label"
@onready var time_played_label = $TimePlayed/Label
@onready var flash_label = $"LevelBox/Panel/MarginContainer/HBoxContainer/Stats/2/Label"
@onready var sprint_label = $"LevelBox/Panel/MarginContainer/HBoxContainer/Stats/3/Label"
@onready var inventory = $LevelBox/Panel/MarginContainer/HBoxContainer/Inventory
@onready var label = $DialogueBox/Panel/MarginContainer/Label

var can_continue_reading = true

func _ready():
	GameManager.connect("update_inventory", _update_inventory)
	DialogueManager.connect("update_dialogue", read)
	DialogueManager.connect("reset_label_ratio", reset_label_ratio)
	_update_inventory()

	reset_read()
	await get_tree().create_timer(0.1).timeout
	DialogueManager.dialogue_type = null
	read()
	pass

func reset_label_ratio():
	label.visible_ratio = 0
	can_continue_reading = false

func _process(delta):
	set_time_played()
	set_health_value()
	set_sprint_amount()
	set_flash_amount()
	pass

func set_time_played():
	time_played_label.text = str(GameManager.time_to_minutes_seconds(GameManager.time_played))
	pass

func set_sprint_amount():
	var sprint_amount = clamp(GameManager.sprint_amount, 0, GameManager.max_sprint)
	sprint_label.text = str(round(sprint_amount))
	pass

func set_health_value():
	var health_amount = clamp(GameManager.health, 0, GameManager.max_health)
	health_label.text = str(health_amount)
	pass

func set_flash_amount():
	flash_label.text = str(round(GameManager.flash_amount))
	pass

func _update_inventory():
	for i in GameManager.inventory.size():
		var texture_path = GameManager.inventory[i].texture_path
		var region_rect = GameManager.inventory[i].region
		inventory.get_child(i).get_child(0).texture = load(texture_path)
		inventory.get_child(i).get_child(0).region_rect = region_rect
	pass

func reset_read():
	DialogueManager.reset_read(label)

func read():
	can_continue_reading = true
	await DialogueManager.read(label)
	
	if !can_continue_reading: return
	if get_tree(): await get_tree().create_timer(2).timeout
	
	if !can_continue_reading: return
	var action = DialogueManager.dialogue_action
	if action != "stop": DialogueManager.next_script()

func _input(event):
	if Input.is_action_just_pressed("skip_dialogue"):
		DialogueManager.skip_dialogue(label)
