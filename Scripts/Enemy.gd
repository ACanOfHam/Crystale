extends KinematicBody2D

var DamageTaken : int
var TotalDamageTaken : int
onready var SwordFrame = get_node("/root/World/Player/Sword/Sprite")
onready var Sword = get_node("/root/World/Player/Sword")
onready var Stats = $Stats
var Follow : bool
var Move = Vector2.ZERO
var knockback = Vector2.ZERO
onready var Player = get_node("/root/World/Player")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	if Follow == true:
		Move = global_position.direction_to(Player.global_position) * $Stats.Speed
	else:
		Move = Vector2.ZERO
		
	Move = Move
	Move = move_and_slide(Move) * $Stats.Speed * delta

func _on_HurtBox_area_entered(area):
	
	knockback = Vector2.ZERO
	knockback = -Player.get_position().normalized() * $Stats.KnockBackMultiplier
	
	get_parent().get_node("SFX").play("Hurt")
	
	$Sprite.hide()
	$FlashTimer.start()
	
	match SwordFrame.frame:
		8:
			DamageTaken = 10 * RandomNumberGenerator.new().randf_range(1, 1.25)
		9:
			DamageTaken = 20 * RandomNumberGenerator.new().randf_range(1, 1.25)
		10:
			DamageTaken = 30 * RandomNumberGenerator.new().randf_range(1, 1.25)
		11:
			DamageTaken = 40 * RandomNumberGenerator.new().randf_range(1, 1.25)
		13:
			DamageTaken = 60 * RandomNumberGenerator.new().randf_range(1, 1.25)
	
	
	Stats.Health -= DamageTaken
	print(Stats.Health)
	
	if Stats.Health <= 0:
		queue_free()


func _on_HitBox_area_entered(area):
	Player.Damage($Stats.Damage)


func _on_DetectionArea_area_entered(area):
	Follow = true


func _on_DetectionArea_area_exited(area):
	Follow = false


func _on_FlashTimer_timeout():
	$Sprite.show()
