extends KinematicBody2D

#Movement variable
var MAX_SPEED: int = 19000
var ACCELERATION: int = MAX_SPEED / 4
const FRICTION: int = 19000
var velocity: Vector2
onready var canDash: bool = true
var input_vector = Vector2.ZERO
var SpeedMultiplier: int = 1
onready var Default_Size = $Sprite.scale
var stamina = 100
var canRegen = true
var knockback = Vector2.ZERO
const KNOCKBACK_SPEED := 170
const KNOCKBACK_FRICTION := 350
var knockback_direction := Vector2.ZERO
var knockback_velocity := Vector2.ZERO

#References
onready var Sword = $Sword
onready var PlayerSprite = $Sprite
onready var DashTimer = $DashTimer
onready var HealthBar = $HUD/GUI/HealthBar/TextureProgress
onready var HealthBarUnder = $HUD/GUI/HealthBar/TextureProgress/TextureProgress_Under
onready var HealthBarTween = $HUD/GUI/HealthBar/UpdateTween
onready var HurtBox = $HurtBox
onready var HurtBoxCollisionShape = $HurtBox/CollisionShape2D
onready var Animationplayer = $AnimationPlayer
onready var TimeTillNextGhost = $TimeTillNextGhost
onready var InvisibilityTimer = $InvisibilityTimer
onready var DashCoolDown = $DashCoolDown

#State Machine
var state
var CanMove: bool = true
enum { 
MOVE, 
DASH, 
DEAD, 
IDLE 
}

#Signals
signal stamina_updated(stamina)
signal health_updated(health)
signal killed
signal damaged

#Health Variables
export (int) var max_health = 100
onready var health = max_health setget Set_Health

#Animation Variables
var Stretch_Finished = true


func _ready():
	HealthBar.value = max_health
	get_parent().get_node("SFX").play("OverWorld_Music")


#This process is called every frame and should not be used for physics
func _process(delta):
	#State Management
	if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
		state = MOVE
	else:
		state = IDLE

	#Getting Mouse Position and flipping character based on where mouse is
	var vert = get_global_mouse_position()
	var gpos = self.get_global_position()
	if gpos.x < vert.x:
		PlayerSprite.set_flip_h(false)
		vert.x = -vert.x  # Our sprite would be facing away from the mouse after flipping
	else:
		PlayerSprite.set_flip_h(true)


#This process is called every physics frame 
func _physics_process(delta):
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, KNOCKBACK_FRICTION * delta)
	knockback_velocity = move_and_slide(knockback_velocity)

	if Input.is_action_just_pressed("dash"):
		state = DASH

	match state:
		DASH:
			dash_state()
		MOVE:
			move_state(delta)
		IDLE:
			idle_state()
		DEAD:
			dead_state()


func move_state(delta):
	if Stretch_Finished == true:
		Animationplayer.play("Run")

	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta) * SpeedMultiplier
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide(velocity)


func idle_state():
	if Stretch_Finished == true:
		Animationplayer.play("Idle")


#Function used for dashing
func dash_state():
	if canDash == true and stamina >= 25:
		stamina = stamina - 25
		Stretch_Finished = false
		Animationplayer.play("Stretch")
		emit_signal("stamina_updated", stamina)
		get_parent().get_node("SFX").play("Dash")
		canDash = false
		SpeedMultiplier = 4
		Create_Ghost()
		DashTimer.start()
		TimeTillNextGhost.start()


func dead_state():
	print("Haha your dead what a noob unless your hamza ofc")


func Create_Ghost():
	var Ghost = preload("res://Scenes/GhostTrail.tscn").instance()
	Ghost.global_position = PlayerSprite.global_position
	Ghost.flip_h = PlayerSprite.flip_h
	Ghost.texture = PlayerSprite.texture
	Ghost.frame = PlayerSprite.frame
	Ghost.scale = PlayerSprite.scale
	get_tree().get_root().add_child(Ghost)


func damage(amount):
	if DashTimer.is_stopped():
		get_parent().get_node("SFX").play("Hurt")
		print(health)
		Set_Health(health - amount)
		emit_signal("damaged")


func Set_Health(Value: int):
	var prev_health = health
	health = clamp(Value, 0, max_health)
	if health != prev_health:
		HealthBarTween.interpolate_property(
			HealthBarUnder,
			"value",
			HealthBarUnder.value,
			health,
			0.4,
			Tween.TRANS_SINE,
			Tween.EASE_OUT
		)
		HealthBar.value = health
		HealthBarTween.start()
		emit_signal("health_updated", health)
		if health == 0:
			dead_state()
			emit_signal("killed")


func _on_Player_damaged():
	PlayerSprite.visible = not PlayerSprite.visible
	InvisibilityTimer.start()


func _on_TimeTillNextGhost_timeout():
	Create_Ghost()


func _on_InvisibilityTimer_timeout():
	HurtBoxCollisionShape.set_disabled(false)
	PlayerSprite.show()


#How long player dashes
func _on_DashTimer_timeout():
	PlayerSprite.scale = Default_Size
	DashCoolDown.start()
	SpeedMultiplier = 1


func _on_DashCoolDown_timeout():
	canDash = true


func _on_HurtBox_area_entered(area):
	if stamina < 100:
		stamina = stamina + 5
		emit_signal("stamina_updated", stamina)
	knockback_direction = HurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED


func _on_AnimationPlayer_animation_finished(Stretch):
	Stretch_Finished = true


func _on_HitBox_area_entered(area):
	if stamina < 100:
		stamina = stamina + 5
		emit_signal("stamina_updated", stamina)
