extends Node

signal update_dialogue
signal next_scene
signal reset_label_ratio


var dialogue_index = 0
var inner_dialogue_index = 0
var dialogue_action = null

var dialogues = [
	[
		{ 
			"text": "Chapter 1",
			"speed": 1,
			"type": null
		},
		{ 
			"text": "This is a story about a young girl and her dad walking in a park. 
			The young girl says daddy I want some ice cream, The dad says 
			wait here, The dad goes to get some ice cream, and coming back.
			Coming back, the girl is gone!",
			"speed": 20,
			"type": null
		},
	],
	[
		
		{
			"text": "Where am I? ",
			"speed": 3,
			"type": null
		},
		{
			"text": "Dad!?",
			"speed": 2,
			"type": null
		},
		{
			"text": "I want my Dad!!!",
			"speed": 1,
			"type": null
		},
	],
	[
		{
			"text": "Tip: Press WASD to Move",
			"speed": 2,
			"type": null
		},
		add_time_delay(3),
		{
			"text": "It's Dark, what does the time say?",
			"speed": 2,
			"type": null
		},
		add_time_delay(3),
		{
			"text": "Objective: Find the clock",
			"speed": 1,
			"type": "stop"
		},
	],
	[
		{
			"text": "10:15pm",
			"speed": 1,
			"type": null
		},
		{
			"text": "It's dark and I can't see",
			"speed": 2,
			"type": null
		},
		{
			"text": "I need to find a flashlight",
			"speed": 2,
			"type": null
		},
		add_time_delay(3),
		{
			"text": "Objective: Find the drawer",
			"speed": 1,
			"type": "stop"
		},
	],
	[
		{
			"text": "Tip: Press 1 or click on the item top right to select",
			"speed": 2,
			"type": null
		},
		{
			"text": "Tip: Press F to activate",
			"speed": 2,
			"type": null
		},
		{
			"text": "Tip: Press F again to deactivate",
			"speed": 2,
			"type": null
		},
		{
			"text": "Tip: Remember you need to save your light",
			"speed": 2,
			"type": null
		},
		add_time_delay(3),
		{
			"text": "Objective: Find Key and Exit the room",
			"speed": 2,
			"type": null
		},
		{
			"text": "Objective: Exit Room Tip: Light up your path",
			"speed": 1,
			"type": "stop"
		},
	],
	[
		{
			"text": "Hide!!!!!!!!!",
			"speed": 1,
			"type": null
		},
		{
			"text": "Tip: Press C to Hide",
			"speed": 1,
			"type": "stop"
		}
		
	],
	[
		{
			"text": "Objective: Exit the house",
			"speed": 2,
			"type": "stop"
		}
	],
	[
		{
			"text": "Rachel escaped the house and kept on running",
			"speed": 3,
			"type": null
		},
		{
			"text": "End of Chapter 1",
			"speed": 1,
			"type": null
		},
	]
	
]

var additional_dialogue = {
	"sprint": [
		{
			"text": "Tip: Press Shift to Run",
			"speed": 2,
			"type": "stop"
		}
	],
	"Books": [
		{
			"text": "Books?",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Do they have harry potter?",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "A book stand?",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "The book of the dead? Interesting",
			"speed": 1,
			"type": "stop"
		}
	],
	"Drawer": [
		{
			"text": "This is a drawer",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Empty..",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Hmm Mentos",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "This opens",
			"speed": 1,
			"type": "stop"
		}
	],
	"Clock": [
		{
			"text": "10:30pm",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Is this working?",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Tick tock says the clock",
			"speed": 1,
			"type": "stop"
		}
	],
	"Mirror": [
		{
			"text": "Mirror Mirror on the wall",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Bloody M.. Nope",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "I look stressed",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Tired",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "At least there's a mirror here",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Mirror",
			"speed": 1,
			"type": "stop"
		}
	],
	"Fridge": [
		{
			"text": "I'm starrving",
			"speed": 1,
			"type": "stop"
		},
		{
			"text": "Is there any food",
			"speed": 1,
			"type": "stop"
		}
	],
	"Door": [
		{
			"text": "Locked..",
			"speed": 2,
			"type": "stop"
		},
		{
			"text": "Need key",
			"speed": 1,
			"type": "stop"
		}
	],
	"Skull": [
		{
			"text": "Turn back now while you still can..",
			"speed": 3,
			"type": "stop"
		},
		{
			"text": "Sacrifice and Blood is the answer..",
			"speed": 3,
			"type": "stop"
		},
		{
			"text": "Only death awaits beyond these doors..",
			"speed": 2,
			"type": "stop"
		},
		{
			"text": "I see your fear. It will not save you..",
			"speed": 2,
			"type": "stop"
		},
		{
			"text": "Your screams will echo for eternity..",
			"speed": 2,
			"type": "stop"
		},
		{
			"text": "They begged for mercy too..",
			"speed": 2,
			"type": "stop"
		},
		{
			"text": "I see your future, Death..",
			"speed": 2,
			"type": "stop"
		},
	]
}
var dialogue_type = null

var tween: Tween = null

func next_script():
	if GameManager.tutorial_ended and !GameManager.game_completed: return
	
	inner_dialogue_index += 1
	
	if dialogue_index >= len(dialogues): return
	
	if inner_dialogue_index >= len(dialogues[dialogue_index]):
		dialogue_index += 1
		inner_dialogue_index = 0
		if dialogue_index <= 1 or dialogue_index >= 7: emit_signal("next_scene")
		else: emit_signal("update_dialogue")
	else:
		emit_signal("update_dialogue")
	pass

func reset_read(label: Label):
	label.visible_ratio = 0
	handle_gameplay()
	pass

func read(label: Label):
	randomize()
	reset_read(label)
	if GameManager.tutorial_ended and !GameManager.game_completed:
		if dialogue_type:
			var read_length = additional_dialogue[dialogue_type].size()
			var randomize_text_index = randi()%read_length
			var randomize_text = additional_dialogue[dialogue_type][randomize_text_index]
			var read_text = randomize_text["text"]
			var read_speed = randomize_text["speed"]
			var read_type = randomize_text["type"]
			dialogue_action = read_type
			
			label.text = str(read_text)
			tween = create_tween()
			tween.play()
			tween.set_ease(Tween.EASE_OUT_IN)
			tween.set_trans(Tween.TRANS_LINEAR)
			#tween.set_trans(Tween.TRANS_QUAD)
			tween.tween_property(label, "visible_ratio", 1, read_speed)
			await tween.finished
		return
	
	if dialogue_index >= len(dialogues): return

	
	var dialogue_index = dialogue_index
	var inner_index = inner_dialogue_index
	var read_text = dialogues[dialogue_index][inner_index]["text"]
	var read_speed = dialogues[dialogue_index][inner_index]["speed"]
	var read_type = dialogues[dialogue_index][inner_index]["type"]
	
	dialogue_action = read_type
	
	label.text = str(read_text)
	tween = create_tween()
	tween.play()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	#tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(label, "visible_ratio", 1, read_speed)
	await tween.finished
	pass

func skip_dialogue(label: Label):
	if !tween: return
	tween.emit_signal("finished")
	tween.stop()
	label.visible_ratio = 1

func empty_dialogue():
	if !tween: return
	tween.emit_signal("finished")
	tween.stop()
	emit_signal("reset_label_ratio")


func handle_gameplay():
	if dialogue_index >= 2:
		GameManager.emit_signal("enable_player_movement")
	pass

func add_time_delay(time):
	return  {
		"text": "",
		"speed": time,
		"type": null
	}

func set_index(_dialogue_index, _inner_index):
	dialogue_index = _dialogue_index
	inner_dialogue_index = _inner_index

func set_type(type):
	dialogue_type = type
	pass
