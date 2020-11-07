extends CanvasLayer

signal scene_changed

onready var animationplayer = $Control/AnimationPlayer
onready var black = $Control/Black

func change_scene(path,delay = 0.25):
	yield(get_tree().create_timer(delay), "timeout")
	animationplayer.play("Fade")
	yield(animationplayer,"animation_finished")
	get_tree().change_scene("res://Scenes/" + path + ".tscn")
	animationplayer.play_backwards("Fade")
	yield(animationplayer,"animation_finished")
	emit_signal("scene_changed")
