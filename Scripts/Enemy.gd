extends KinematicBody2D

var DamageTaken : int
var TotalDamageTaken : int
onready var SwordFrame = get_node("/root/World/Player/Sword/Sprite")
onready var Sword = get_node("/root/World/Player/Sword")
onready var SwordHitbox = get_node("/root/World/Player/Sword/Hitbox")
onready var Stats = $Stats
var Move = Vector2.ZERO
var knockback = Vector2.ZERO
onready var Player = get_node("/root/World/Player")
enum {
	IDLE,
	CHASE,
	WANDER
}
var state = IDLE
const KNOCKBACK_SPEED := 170
const KNOCKBACK_FRICTION := 350
var knockback_direction := Vector2.ZERO
var knockback_velocity := Vector2.ZERO


func _physics_process(delta):
	
	match state:
		IDLE:
			pass
		CHASE:
			Move_State(delta)
		WANDER:
			pass
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)
	
	
	Move = Vector2.ZERO
	


func _on_HurtBox_area_entered(area):
	knockback_direction = $HurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * $Stats.KnockBackMultiplier
	
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

func Move_State(delta):

	if Move.x > 1:
		get_node("Sprite").set_flip_h(true)
	else:
		get_node("Sprite").set_flip_h(false)
		
	Move = (Player.global_position - global_position).normalized() * $Stats.Speed
	Move = move_and_slide(Move) * $Stats.Speed * delta

func _on_HitBox_area_entered(area):
	Player.Damage($Stats.Damage)
	state = IDLE
	$RestTimer.start()


func _on_DetectionArea_area_entered(area):
	state = CHASE


func _on_DetectionArea_area_exited(area):
	state = IDLE


func _on_FlashTimer_timeout():
	$Sprite.show()


func _on_RestTimer_timeout():
	state = CHASE
