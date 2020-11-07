extends KinematicBody2D
class_name Enemy

signal finished_damage_logic

var old_shape = null
var floaty_text_scene = preload("res://Scenes/FloatingText.tscn")
#onready var SwordFrame: Sprite = get_node("/root/World/Player/Sword/Sprite")
var player
onready var alert = $Alert
onready var invincibility_timer = $InvincibilityTimer
onready var stats: Node = $Stats
onready var enemy_sprite: Sprite = $Sprite
onready var enemy_hurtBox: Area2D = $HurtBox
onready var flash_timer: Timer = $FlashTimer
onready var rest_timer: Timer = $RestTimer
onready var acceleration: int = stats.speed/4
onready var animationplayer = $AnimationPlayer
var move: Vector2 = Vector2.ZERO
var rng =  RandomNumberGenerator.new()
var knockback: Vector2 = Vector2.ZERO
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
	yield(self, "finished_damage_logic")
	knockback_direction = enemy_hurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	if area.get_parent().name != "Arrow":
		knockback_velocity = knockback_direction * stats.knockback_multiplier
	else:
		knockback_velocity = knockback_direction * stats.knockback_multiplier/2



func move_state(delta):
	player = get_parent().get_node("Player")
	animationplayer.play("Move")
	move = (player.global_position - global_position).normalized() * stats.speed
	move = move_and_slide(move) * stats.speed * delta


func damage(value: int):
	player = get_parent().get_node("Player")
	rng.randomize()
	damage_multiplier = rng.randf_range(1,1.5)
	
	value = value * damage_multiplier
	
	disable(enemy_hurtBox)
	
	invincibility_timer.start()
	
	var floaty_text = floaty_text_scene.instance()
	floaty_text.text = null
	
	Sounds.playsfx("Hurt")

#	EnemySprite.hide()
	enemy_sprite.get_material().set_shader_param("whitening", 1)

	flash_timer.start()
	floaty_text.position = Vector2(0,0)
	floaty_text.velocity = Vector2(rand_range(-50, 50), -100)
	
	if damage_multiplier >= 1.4:
		floaty_text.modulate = Color("FFD700") 
	
	stats.health -= value
	floaty_text.text = str(value)
	add_child(floaty_text)
	
	if stats.health <= 0:
		player.add_mana(40)
		queue_free()
	
	emit_signal("finished_damage_logic")


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
