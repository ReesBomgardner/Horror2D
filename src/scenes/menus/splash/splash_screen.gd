extends Control

@export var splash = false
@export var next_scene: PackedScene
@onready var percentage = $CenterContainer/Label/Percentage
@onready var anim = $AnimationPlayer

func _ready():
	if !splash: queue_free()
	animate_percentage()
	pass

func animate_percentage():
	var tween = create_tween()
	var tween2 = create_tween()
	
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_method(_update_percentage, 0, 100, 4.0)
	
	tween2.set_ease(Tween.EASE_OUT_IN)
	tween2.set_trans(Tween.TRANS_BOUNCE)
	tween2.tween_method(_update_method, Color.RED, Color.WHITE, 4.0)
	
	await anim.animation_finished
	anim.play("fade-out")
	
	await anim.animation_finished
	queue_free()
	pass

func _update_percentage(value):
	percentage.text = str(value) + "%"

func _update_method(value):
	percentage.modulate = value
