extends KinematicBody2D

signal Damage
var DamageTaken : int
var TotalDamageTaken : int
onready var SwordFrame = get_node("/root/World/Player/Sword/Sprite")
onready var Stats = $Stats
onready var Player = get_node("/root/World/Player")


func _on_HurtBox_area_entered(area):
	
	match SwordFrame.frame:
		8:
			DamageTaken = 15 * RandomNumberGenerator.new().randf_range(1, 1.25)
		9:
			DamageTaken = 25 * RandomNumberGenerator.new().randf_range(1, 1.25)
		10:
			DamageTaken = 35 * RandomNumberGenerator.new().randf_range(1, 1.25)
		11:
			DamageTaken = 40 * RandomNumberGenerator.new().randf_range(1, 1.25)
		13:
			DamageTaken = 60 * RandomNumberGenerator.new().randf_range(1, 1.25)
	
	Stats.Health -= DamageTaken
	print(Stats.Health)
	
	if Stats.Health <= 0:
		queue_free()


func _on_HitBox_area_entered(area):
	Player.Take_Damage($Stats.Damage)
