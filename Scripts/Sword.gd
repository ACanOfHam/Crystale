extends Area2D

signal Isnt_Using_Sword
signal Is_Using_Sword

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Attack"):
		emit_signal("Is_Using_Sword")
		$AttackTimer.start()
		$AnimationPlayer.play("Attack")



func _on_AttackTimer_timeout():
	emit_signal("Isnt_Using_Sword")
