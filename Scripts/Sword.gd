extends Area2D

var canPlaySFX = true
onready var Player = get_node("/root/World/Player")

func _process(delta):
	look_at(get_global_mouse_position())
	
	
	
	if Input.is_action_just_pressed("Attack"):
		$AnimationPlayer.play("Attack")
		get_parent().get_parent().get_node("SFX").play("Sword_Slash")
		canPlaySFX = false



