extends CanvasLayer

onready var play_label = $Play/PlayLabel
onready var quit_label = $Quit/QuitLabel

func _on_Play_pressed():
	self.layer = 0
	SceneChanger.change_scene("World")
	


func _on_Play_button_down():
	play_label.set_position(Vector2(7, 1.5))


func _on_Play_button_up():
	play_label.set_position(Vector2(7, 0.75))


func _on_Quit_button_down():
	quit_label.set_position(Vector2(8.77, 1.5))


func _on_Quit_button_up():
	quit_label.set_position(Vector2(8.77, 0.868))


func _on_Quit_pressed():
	get_tree().quit()
