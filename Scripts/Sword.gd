extends Area2D

onready var animationPlayer:AnimationPlayer = $AnimationPlayer
onready var AttackTimer: Timer = $SoundTimer
var canPlaySFX: bool = false
onready var Player: KinematicBody2D = get_owner().get_node("Player")
#onready var Sounds = get_parent().get_owner().get_node("Sounds")

func _ready():
	canPlaySFX = true

func _process(_delta):
	look_at(get_global_mouse_position())
	
	
	
	if Input.is_action_just_pressed("Attack") and canPlaySFX == true:
		AttackTimer.start()
		animationPlayer.play("Attack")
		Sounds.playsfx("Sword_Slash")
		canPlaySFX = false


func _on_AnimationPlayer_animation_finished(Attack):
	canPlaySFX = true
