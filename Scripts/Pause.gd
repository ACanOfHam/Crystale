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
			AnimationPlayer.play("FadeIn")
			get_owner().get_node("Player/HUD/GUI").visible = false
			i = 1
		elif i == 1:
			Paused.visible = false
			get_tree().paused = false
			i = 0
			AnimationPlayer.play("FadeOut")
			get_owner().get_node("Player/HUD/GUI").visible = true
