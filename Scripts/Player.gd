extends KinematicBody2D

#Movement variable
var MAX_SPEED: int = 19000
var ACCELERATION: int = MAX_SPEED / 4
const FRICTION: int = 19000
var velocity: Vector2
onready var canDash: bool = true
var input_vector: Vector2 = Vector2.ZERO
var SpeedMultiplier: int = 1
onready var Default_Size = $Sprite.scale
var mana: int = 100
var canRegen: bool = true
var knockback: Vector2 = Vector2.ZERO
const KNOCKBACK_SPEED: int = 170
const KNOCKBACK_FRICTION: int = 350
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO

#References
onready var Sounds = get_parent().get_node("Sounds")
onready var Sword: Area2D = $Sword
onready var PlayerSprite: Sprite = $Sprite
onready var DashTimer: Timer = $DashTimer
onready var HealthBar: TextureProgress = $HUD/GUI/HealthBar/TextureProgress
onready var HealthBarUnder: TextureProgress = $HUD/GUI/HealthBar/TextureProgress/TextureProgress_Under
onready var HealthBarTween: Tween = $HUD/GUI/HealthBar/UpdateTween
onready var HurtBox: Area2D = $HurtBox
onready var HurtBoxCollisionShape: CollisionShape2D = $HurtBox/CollisionShape2D
onready var Animationplayer: AnimationPlayer = $AnimationPlayer
onready var TimeTillNextGhost: Timer = $TimeTillNextGhost
onready var InvisibilityTimer: Timer = $InvisibilityTimer
onready var DashCoolDown: Timer = $DashCoolDown
onready var Shadow: Sprite = $Shadow

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
signal mana_updated(mana)
signal health_updated(health)
signal killed
signal damaged

#Health Variables
export (int) var max_health = 100
onready var health: int = max_health setget Set_Health

#Animation Variables
var Stretch_Finished = true


func _ready():
	Sounds.playmusic("OverWorld_Music")


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
		Shadow.position.x = 1.156
		vert.x = -vert.x  # Our sprite would be facing away from the mouse after flipping
	else:
		PlayerSprite.set_flip_h(true)
		Shadow.position.x = -1.345


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
	if canDash == true and mana >= 25:
		mana = mana - 25
		self.set_collision_mask_bit(2, false)
		Stretch_Finished = false
		Animationplayer.play("Stretch")
		emit_signal("mana_updated", mana)
		Sounds.playsfx("Dash")
		canDash = false
		SpeedMultiplier = 4
		Create_Ghost()
		DashTimer.start()
		TimeTillNextGhost.start()


func dead_state():
#	get_tree().paused = true
	pass


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
		Sounds.playsfx("Hurt")
		print(health)
		Set_Health(health - amount)
		emit_signal("damaged")


func Set_Health(Value: int):
	health = clamp(Value, 0, max_health)
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
	self.set_collision_mask_bit(2, true)



func _on_DashCoolDown_timeout():
	canDash = true


func _on_HurtBox_area_entered(area):
	if mana < 100:
		mana = mana + 5
		emit_signal("mana_updated", mana)
	knockback_direction = HurtBox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED


func _on_AnimationPlayer_animation_finished(Stretch):
	Stretch_Finished = true


func _on_HitBox_area_entered(_area):
	if mana < 100:
		mana = mana + 5
		emit_signal("mana_updated", mana)

func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
