extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var AttackTimer = $SoundTimer
var canPlaySFX = false
onready var Player = get_node("/root/World/Player")

func _process(delta):
	look_at(get_global_mouse_position())
	
	
	
	if Input.is_action_just_pressed("Attack") and canPlaySFX == true:
		AttackTimer.start()
		$AnimationPlayer.play("Attack")
		get_parent().get_parent().get_node("SFX").play("Sword_Slash")
		canPlaySFX = false


func _on_AnimationPlayer_animation_finished(Attack):
	canPlaySFX = true
