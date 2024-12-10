extends Node2D

@onready var bg_music = $BgMusic
@onready var bg_music2 = $BgMusic2

@onready var door_sound = $DoorSound
@onready var door_locked_sound = $DoorLockedSound

var change_track = false
func _ready():
	GameManager.connect("play_door_sound", play_door_sound)
	GameManager.connect("change_track", _change_track)
	GameManager.connect("player_locked_door_sound", play_door_locked_sound)
	pass


func play_door_sound():
	door_sound.play()
	pass

func play_door_locked_sound():
	door_locked_sound.play()
	pass

func _change_track(value):
	change_track = value
	if change_track:
		bg_music2.play()
		bg_music.stream_paused = true
	else:
		bg_music.play()
		bg_music2.stream_paused = true
	pass
