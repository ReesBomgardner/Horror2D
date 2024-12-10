extends CanvasModulate

var normal_color = Color("0024b0")
var blink_color = Color("520000")

func _ready():
	GameManager.connect("player_bleeds", blink)
	pass

func blink():
	var tween = create_tween()
	
	tween.play()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "color", blink_color, 0.05)
	
	await tween.finished
	tween.stop()
	
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "color", normal_color, 0.05)
	tween.play()
	
	pass
