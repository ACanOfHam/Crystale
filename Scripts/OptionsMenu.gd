extends Control

onready var music_slider = $MusicSlider
onready var back_label = $BackButton/BackButtonLabel

func _ready():
#	Sounds.playmusic("OverWorld_Music")
	pass


func _on_MusicSlider_value_changed(value):
	Sounds.change_music_volume(int(value))


func _on_SFXSlider_value_changed(value):
	Sounds.change_sfx_volume(int(value))
	Sounds.playsfx("Hurt")


func _on_BackButton_pressed():
	SceneChanger.change_scene("Menu")


func _on_BackButton_button_up():
	back_label.set_position(Vector2(7.029, 1))


func _on_BackButton_button_down():
	back_label.set_position(Vector2(7.029, 1.75))
