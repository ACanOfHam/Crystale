extends KinematicBody2D


var old_shape = null
var floaty_text_scene = preload("res://Scenes/FloatingText.tscn")
var damage_taken: int
var total_damage_taken: int
#onready var SwordFrame: Sprite = get_node("/root/World/Player/Sword/Sprite")
onready var alert = $Alert
onready var invincibility_timer = $InvincibilityTimer
onready var sword_frame: Sprite = get_parent().get_node("Player").get_node("Sword/Sprite")
onready var stats: Node = $Stats
onready var enemy_sprite: Sprite = $Sprite
onready var enemy_hurtBox: Area2D = $HurtBox
onready var flash_timer: Timer = $FlashTimer
onready var rest_timer: Timer = $RestTimer
onready var sounds: Node = get_owner().get_node("Sounds")
onready var acceleration: int = stats.speed/4
onready var animationplayer = $AnimationPlayer
var move: Vector2 = Vector2.ZERO
var rng =  RandomNumberGenerator.new()
var knockback: Vector2 = Vector2.ZERO
onready var player: KinematicBody2D = get_parent().get_node("Player")
var damage_multiplier
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
			idle_state()
		CHASE:
			move_state(delta)
	
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)



func _on_HurtBox_area_entered(area):
	rng.randomize()
	damage_multiplier = rng.randf_range(1,1.5)
	disable(enemy_hurtBox)
	invincibility_timer.start()
	knockback_direction = enemy_hurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * stats.knockBackMultiplier
	var floaty_text = floaty_text_scene.instance()
	floaty_text.text = null
	sounds.playsfx("Hurt")
#	EnemySprite.hide()
	enemy_sprite.get_material().set_shader_param("whitening", 1)
	flash_timer.start()
	floaty_text.position = Vector2(0,0)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	
	match sword_frame.frame:
		8:
			damage_taken = 10 * damage_multiplier
		9:
			damage_taken = 20 * damage_multiplier
		10:
			damage_taken = 30 * damage_multiplier
		11:
			damage_taken = 40 * damage_multiplier
		13:
			damage_taken = 60 * damage_multiplier
	
	if damage_multiplier >= 1.4:
		floaty_text.modulate = Color("FFD700") 
	
	stats.health -= damage_taken
	floaty_text.text = damage_taken
	add_child(floaty_text)
	
	if stats.health <= 0:
		player.add_mana(40)
		queue_free()

func move_state(delta):
	animationplayer.play("Move")
	move = (player.global_position - global_position).normalized() * stats.speed
	move = move_and_slide(move) * stats.speed * delta


func idle_state():
	enemy_sprite.frame = 0


func _on_HitBox_area_entered(area):
	player.damage(stats.damage)
	state = IDLE
	rest_timer.start()


func _on_DetectionArea_area_entered(area):
	state = CHASE
	alert.visible = true

func _on_DetectionArea_area_exited(area):
	state = IDLE
	animationplayer.play("AlertDisappear")


func _on_FlashTimer_timeout():
	enemy_sprite.show()
	enemy_sprite.get_material().set_shader_param("whitening", 0)


func _on_RestTimer_timeout():
	state = CHASE


func _on_InvinsibilityTimer_timeout():
	enable(enemy_hurtBox)

func disable(area):
	area.set_collision_layer_bit(5, false)

func enable(area):
	area.set_collision_layer_bit(5, true)
