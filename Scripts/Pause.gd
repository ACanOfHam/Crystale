extends CanvasLayer

var i = 0
onready var Paused = $Paused
onready var TextureRect = $TextureRect
onready var AnimationPlayer = $AnimationPlayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if i == 0:
			Paused.visible = true
			get_tree().paused = true
			TextureRect.visible = true
			i = 1
			AnimationPlayer.play("FadeIn")
		elif i == 1:
			Paused.visible = false
			get_tree().paused = false
			i = 0
			AnimationPlayer.play("FadeOut")
