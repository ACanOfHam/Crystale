extends Area2D

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Attack"):
		$AnimationPlayer.play("Attack")



