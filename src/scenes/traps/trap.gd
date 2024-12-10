extends Area2D

@export var time_delay: float = 1.0

@onready var timer = $Timer
@onready var anim = $AnimationPlayer

var damage = 1

func _ready():
	timer.wait_time = time_delay
	timer.start()
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.hiding: return
		var knockback_dir = global_position.direction_to(body.global_position)
		body.start_take_damage(damage, knockback_dir)
		pass
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("player"):
		if body.hiding: return
		body.stop_take_damage()
		pass
	pass # Replace with function body.

func activate():
	anim.play("activate")
	await anim.animation_finished
	
	timer.start()
	pass

func _on_timer_timeout():
	activate()
	pass # Replace with function body.
