extends Node2D

func Play(music = null):
	if music:
		get_node(music).play()
	else:
		print("Music not found")
