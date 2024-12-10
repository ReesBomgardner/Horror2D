extends Camera2D

var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var original_offset: Vector2 = Vector2.ZERO

var continous_shake = false

func _ready():
	GameManager.connect("shake_screen", start_shake)
	GameManager.connect("start_continuous_shake", start_continuous_shake)
	GameManager.connect("end_continuous_shake", end_continuous_shake)
	original_offset = offset

func _process(delta: float):
	if shake_duration > 0.0 or continous_shake:
		shake_duration -= delta
		offset = original_offset + Vector2(
		randf_range(-shake_intensity, shake_intensity),
		randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = original_offset

func start_shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration

func start_continuous_shake():
	continous_shake = true
	shake_intensity = 5
	pass

func end_continuous_shake():
	continous_shake = false
	pass
