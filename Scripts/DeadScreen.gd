extends Control


onready var menu_label = $MenuButton/MenuLabel

func _on_MenuButton_pressed():
	SceneChanger.change_scene("Menu")


func _on_MenuButton_button_up():
	menu_label.set_position(Vector2(7.517, 0.75))


func _on_MenuButton_button_down():
	menu_label.set_position(Vector2(7.517, 1.5))
