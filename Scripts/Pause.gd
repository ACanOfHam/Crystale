extends CanvasLayer

var i = 0
onready var Paused = $Paused
onready var TextureRect = $TextureRect
onready var AnimationPlayer = $AnimationPlayer
onready var quit_label = $Quit/QuitLabel
onready var quit_button = $Quit

#TODO: THIS IS SUCH A SHITTY WAY TO DO THIS FIX THIS NIGGA 

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if i == 0:
			Paused.visible = true
			get_tree().paused = true
			TextureRect.visible = true
			quit_button.visible = true
			i = 1
			AnimationPlayer.play("FadeIn")
		elif i == 1:
			Paused.visible = false
			get_tree().paused = false
			quit_button.visible = false
			i = 0
			AnimationPlayer.play("FadeOut")

func _on_Quit_button_down():
	quit_label.set_position(Vector2(8.77, 1.5))


func _on_Quit_button_up():
	quit_label.set_position(Vector2(8.77, 0.868))


func _on_Quit_pressed():
	get_tree().quit()
