extends KinematicBody2D

var old_shape = null
var floaty_text_scene = preload("res://Scenes/FloatingText.tscn")
var DamageTaken: int
var TotalDamageTaken: int
#onready var SwordFrame: Sprite = get_node("/root/World/Player/Sword/Sprite")
onready var InvincibilityTimer = $InvincibilityTimer
onready var SwordFrame: Sprite = get_owner().get_node("Sort/Player/Sword/Sprite")
onready var Stats: Node = $Stats
onready var EnemySprite: Sprite = $Sprite
onready var EnemyHurtBox: Area2D = $HurtBox
onready var FlashTimer: Timer = $FlashTimer
onready var RestTimer: Timer = $RestTimer
onready var Sounds: Node = get_owner().get_node("Sounds")
onready var Acceleration: int = Stats.speed/4
onready var Animationplayer = $AnimationPlayer
var Move: Vector2 = Vector2.ZERO
var rng =  RandomNumberGenerator.new()
var knockback: Vector2 = Vector2.ZERO
onready var Player: KinematicBody2D = get_owner().get_node("Sort/Player")
var DamageMultiplier
enum {
	IDLE,
	CHASE,
	WANDER
}
var state = IDLE
const KNOCKBACK_SPEED: int = 170
const KNOCKBACK_FRICTION: int = 350
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	
	match state:
		IDLE:
			Idle_State()
		CHASE:
			Move_State(delta)
		WANDER:
			pass
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)



func _on_HurtBox_area_entered(area):
	rng.randomize()
	DamageMultiplier = rng.randf_range(1,1.5)
	disable(EnemyHurtBox)
	InvincibilityTimer.start()
	knockback_direction = EnemyHurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * Stats.knockBackMultiplier
	var floaty_text = floaty_text_scene.instance()
	floaty_text.text = null
	Sounds.playsfx("Hurt")
#	EnemySprite.hide()
	EnemySprite.get_material().set_shader_param("whitening", 1)
	FlashTimer.start()
	floaty_text.position = Vector2(0,0)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	
	match SwordFrame.frame:
		8:
			DamageTaken = 15 * DamageMultiplier
		9:
			DamageTaken = 25 * DamageMultiplier
		10:
			DamageTaken = 35 * DamageMultiplier
		11:
			DamageTaken = 45 * DamageMultiplier
		13:
			DamageTaken = 65 * DamageMultiplier
	
	if DamageMultiplier >= 1.4:
		floaty_text.modulate = Color("FFD700") 
	
	Stats.health -= DamageTaken
	floaty_text.text = DamageTaken
	add_child(floaty_text)
	
	if Stats.health <= 0:
		queue_free()

func Move_State(delta):
	Animationplayer.play("Move")
#	if Move.x > 1:
#		EnemySprite.set_flip_h(false)
#	else:
#		EnemySprite.set_flip_h(true)

	Move = (Player.global_position - global_position).normalized() * Stats.speed
	if EnemySprite.frame >= 9:
		if Move.x > 1:
			EnemySprite.set_flip_h(false)
		else:
			EnemySprite.set_flip_h(true)
		Move = Vector2(0,0)
		Stats.knockBackMultiplier = 15
	else:
		if Move.x > 1:
			EnemySprite.set_flip_h(false)
		else:
			EnemySprite.set_flip_h(true)
		Stats.knockBackMultiplier = 300
	Move = move_and_slide(Move) * Stats.speed * delta


func Idle_State():
	EnemySprite.frame = 0


func _on_HitBox_area_entered(_area):
	Player.damage(Stats.damage)


func _on_DetectionArea_area_entered(_area):
	state = CHASE
	$Alert.visible = true

func _on_DetectionArea_area_exited(_area):
	state = IDLE
	$AnimationPlayer.play("AlertDisappear")


func _on_FlashTimer_timeout():
	EnemySprite.show()
	EnemySprite.get_material().set_shader_param("whitening", 0)


func _on_InvinsibilityTimer_timeout():
	enable(EnemyHurtBox)

func disable(area):
	area.set_collision_layer_bit(5, false)

func enable(area):
	area.set_collision_layer_bit(5, true)
