extends Node2D

func Play(sfx = null):
	if sfx:
		get_node(sfx).play()
	else:
		print("SoundEffect not found")
