extends Area2D

var arrow = preload("res://Scenes/Arrow.tscn")
var can_shoot = true

func _process(delta):
	if get_parent().get_node("Sprite").flip_h == true:
		position.x = -10
	else:
		position.x = 10
	look_at(get_global_mouse_position())

func _input(event):
	if event.is_action_pressed("Attack"):
		shoot()

func shoot():
	if can_shoot:
		Sounds.playsfx("Sword_Slash")
		var arrow_instace = arrow.instance()
		arrow_instace.transform = transform
		arrow_instace.position = self.global_position
		get_parent().get_parent().get_parent().add_child(arrow_instace, true)
		can_shoot = false
		yield(get_tree().create_timer(0.425), "timeout")
		can_shoot = true
