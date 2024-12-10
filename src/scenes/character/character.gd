extends CharacterBody2D

@onready var animTree = $AnimationTree
@onready var flashlight = $Flashlight
@onready var anim = $AnimationPlayer
@onready var interact_anim = $InteractButton/AnimationPlayer
@onready var take_damage_timer = $TakeDamageTimer
@onready var collision_shape = $CollisionShape2D
@onready var interact_button = $InteractButton/Sprite2D
@onready var movement_sound = $MovementSound
@onready var flashlight_hitter = $FlashlightHit/CollisionShape2D



var speed = 200.0
const MAIN_SPEED = 200.0
const SPRINT_SPEED = 300.0
var direction = Vector2.ZERO
var idle_direction = Vector2.ZERO

var damage_value = 1

var hiding = false
var can_hide = false
var is_sprinting = false
var playing_movement_sound = false

var can_move = false # Using dailogue_index to block this

#KNOCK BACK
var knockback_velocity = Vector2.ZERO
var is_knocked_back = false
var knockback_duration = 0.2
var knockback_timer = 0.0
var knockback_strength = 300
var knockback_direction = Vector2.ZERO

var can_knockback = false


func _ready():
	animTree.active = true
	flashlight.enabled = GameManager.flashlight_active
	flashlight_hitter.disabled = !GameManager.flashlight_active
	
	GameManager.connect("player_hides", _hide_player)
	GameManager.connect("enable_player_movement", enable_movement)
	pass

func enable_movement():
	can_move = true
	pass

func apply_knockback(direction: Vector2):
	is_knocked_back = true
	knockback_timer = knockback_duration
	knockback_velocity = direction.normalized() * knockback_strength

func deactivate_flashlight_hit(value: bool):
	flashlight_hitter.disabled = value
	pass

func _physics_process(delta):
	if hiding: return
	if !can_move: return

	if is_knocked_back:
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knocked_back = false
			knockback_velocity = Vector2.ZERO
	
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction != Vector2.ZERO: 
		idle_direction = direction
		if !playing_movement_sound:
			movement_sound.play()
			playing_movement_sound = true
	else:
		if playing_movement_sound:
			movement_sound.stop()
			playing_movement_sound = false
	
	var idle_walk_blend = 0 if !idle_direction else 1 if direction else -1
	animTree.set('parameters/move/blend_position', idle_walk_blend)
	animTree.set('parameters/move/0/blend_position', idle_direction)
	animTree.set('parameters/move/1/blend_position', direction)
	
	velocity = direction.normalized() * speed
	if is_knocked_back: velocity = knockback_velocity

	move_and_slide()

func _process(delta):
	if is_sprinting: GameManager.sprint_amount = maxf(GameManager.sprint_amount - delta, 0)
	else: GameManager.sprint_amount = lerpf(GameManager.sprint_amount, GameManager.max_sprint, 0.003)
	
	if GameManager.flashlight_active:
		GameManager.flash_amount = maxf(GameManager.flash_amount -delta, 0)
	if GameManager.flash_amount <= 0 and GameManager.flashlight_active:
		GameManager.flashlight_active = false
		flashlight.enabled = false
		deactivate_flashlight_hit(true)
	pass

func _input(event):
	if hiding: return
	if !can_move: return
	
	if Input.is_action_just_pressed("flashlight") and GameManager.flash_amount > 0:
		var flashlight_active = GameManager.flashlight_active
		GameManager.flashlight_active = !flashlight_active
		flashlight.enabled = !flashlight_active
		deactivate_flashlight_hit(flashlight_active)
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		if GameManager.sprint_amount > 0: speed = SPRINT_SPEED
		else: speed = MAIN_SPEED
		movement_sound.pitch_scale = 0.9
	else:
		speed = MAIN_SPEED
		is_sprinting = false
		movement_sound.pitch_scale = 0.6

	pass

func _hide_player():
	GameManager.flashlight_active = false
	flashlight.enabled = false
	
	deactivate_flashlight_hit(true)
	movement_sound.stop()
	
	hiding = !hiding
	collision_shape.disabled = hiding
	if hiding:
		EnemyNavigationManager.emit_signal("stop_chasing_player")
		hide()
	else:
		show()
	
func interact(condition: bool, rect = Rect2(33,17,14,13)):
	interact_button.region_rect = rect
	if condition: 
		interact_anim.play("intro")
	else: 
		interact_anim.play("outro")

func start_take_damage(value, direction = Vector2.ZERO):
	take_damage_timer.start()
	damage_value = value
	if direction: 
		can_knockback = true
		knockback_direction = direction
	pass

func stop_take_damage():
	damage_value = 1
	take_damage_timer.stop()
	can_knockback = false
	pass

func take_damage():
	if can_knockback: apply_knockback(knockback_direction)
	GameManager.health -= damage_value
	if GameManager.health <= 0:
		GameManager.emit_signal("game_ended")
		take_damage_timer.stop()
		pass
	pass

func _on_take_damage_timer_timeout():
	take_damage()
	GameManager.emit_signal("player_bleeds")
	GameManager.emit_signal("shake_screen", 20, 0.2)
	pass # Replace with function body.



func _on_flashlight_hit_area_entered(area):
	if area.is_in_group("enemy"):
		var body = area.get_parent()
		body.start_slow_down()
	pass # Replace with function body.


func _on_flashlight_hit_area_exited(area):
	if area.is_in_group("enemy"):
		var body = area.get_parent()
		body.end_slow_down()
	pass # Replace with function body.
