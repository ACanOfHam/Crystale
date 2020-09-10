extends Sprite

onready var tween : Tween = $Tween

func _ready():	
	tween.interpolate_property(self , 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT) 
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
