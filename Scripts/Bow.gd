extends Area2D

var arrow = preload("res://Scenes/Arrow.tscn")

func _process(delta):
	if get_parent().get_node("Sprite").flip_h == true:
		position.x = -10
	else:
		position.x = 10
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Attack"):
		shoot()

func shoot():
	Sounds.playsfx("Sword_Slash")
	var arrow_instace = arrow.instance()
	arrow_instace.transform = transform
	arrow_instace.position = Vector2(global_position)
	get_parent().get_parent().get_parent().add_child(arrow_instace)
