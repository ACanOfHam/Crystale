extends KinematicBody2D

#Movement variable
var MAX_SPEED: int = 90000
var ACCELERATION: int = MAX_SPEED / 4
const FRICTION: int = 90000
var velocity: Vector2
onready var can_dash: bool = true
var input_vector: Vector2 = Vector2.ZERO
var SpeedMultiplier: int = 1
onready var Default_Size = $Sprite.scale
onready var mana: int = 100 
var can_regen: bool = true
var knockback: Vector2 = Vector2.ZERO
const KNOCKBACK_SPEED: int = 295
const KNOCKBACK_FRICTION: int = 350
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO

#References
var sounds
#onready var Sword: Area2D = $Sword
export (NodePath) onready var sword
#onready var PlayerSprite: Sprite = $Sprite
export (NodePath) onready var player_sprite
#onready var DashTimer: Timer = $DashTimer
export (NodePath) onready var dash_timer
#onready var HealthBar: TextureProgress = $HUD/GUI/HealthBar/TextureProgress
export (NodePath) onready var health_bar
#onready var HealthBarUnder: TextureProgress = $HUD/GUI/HealthBar/TextureProgress/TextureProgress_Under
export (NodePath) onready var health_bar_under
#onready var HealthBarTween: Tween = $HUD/GUI/HealthBar/UpdateTween
export (NodePath) onready var health_bar_tween
#onready var HurtBox: Area2D = $HurtBox
export (NodePath) onready var hurtbox
#onready var Animationplayer: AnimationPlayer = animation_player
export (NodePath) onready var animationplayer
#onready var TimeTillNextGhost: Timer = $TimeTillNextGhost
export (NodePath) onready var time_till_next_ghost
#onready var InvisibilityTimer: Timer = $InvisibilityTimer
export (NodePath) onready var invisibility_timer
#onready var DashCoolDown: Timer = $DashCoolDown
export (NodePath) onready var dash_cool_down
#onready var Shadow: Sprite = $Shadow
export (NodePath) onready var shadow
#onready var HurtBoxCollisionShape = $HurtBox/CollisionShape2D
export (NodePath) onready var hurtbox_collision_shape
export (NodePath) onready var collision_shape

#State Machine
var state
var can_move: bool = true
enum { 
MOVE, 
DASH, 
DEAD, 
IDLE 
}
var has_died: bool = false

#Signals
signal mana_updated(mana)
signal health_updated(health)
signal killed
signal damaged

#Health Variables
export (int) var max_health = 100
onready var health: int = max_health setget set_health

#Animation Variables
var stretch_finished = true
var current_animation
var new_animation

func _ready():
	Get_References()

#This process is called every frame and should not be used for physics
func _process(delta):
		#State Management
	if has_died == false:
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
			state = MOVE
		else:
			state = IDLE
		
		#Toggle Console
		if Input.is_action_just_pressed("toggle_console"):
			get_owner().add_child(load("res://Scenes/Console.tscn").instance())
			get_tree().paused = true
	
	#Getting Mouse Position and flipping character based on where mouse is
	if has_died == false:
		var vert = get_global_mouse_position()
		var gpos = self.get_global_position()
		if gpos.x < vert.x:
			player_sprite.set_flip_h(false)
			shadow.position.x = -1.118
			collision_shape.position.x = -1.118
			vert.x = -vert.x  # Our sprite would be facing away from the mouse after flipping
		else:
			player_sprite.set_flip_h(true)
			shadow.position.x = -3.5
			collision_shape.position.x = -3.5


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
	play_animation("Run")

	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if SpeedMultiplier < 1 and SpeedMultiplier != 0:
			SpeedMultiplier = 1
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta) * SpeedMultiplier
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide(velocity)
	velocity = Vector2.ZERO


func idle_state():
	play_animation("Idle")


#Function used for dashing
func dash_state():
	if can_dash == true:
		if remove_mana(20) == true:
			self.set_collision_mask_bit(2, false)
			sounds = get_owner().get_node("Sounds")
			sounds.playsfx("Dash")
			can_dash = false
			SpeedMultiplier = SpeedMultiplier * 4
			create_ghost()
			dash_timer.start()
			time_till_next_ghost.start()


func dead_state():
	has_died = true
	SceneChanger.change_scene("DeadScreen")
	if sword != null:
		sword.queue_free()
	if player_sprite != null:
		player_sprite.queue_free()
	if shadow != null:
		shadow.queue_free()



func create_ghost():
	var ghost = preload("res://Scenes/GhostTrail.tscn").instance()
	ghost.global_position = player_sprite.global_position
	ghost.flip_h = player_sprite.flip_h
	ghost.texture = player_sprite.texture
	ghost.frame = player_sprite.frame
	ghost.scale = player_sprite.scale
	get_tree().get_root().add_child(ghost)


func damage(amount):
	if dash_timer.is_stopped():
		sounds = get_owner().get_node("Sounds")
		sounds.playsfx("Hurt")
		print(health)
		set_health(health - amount)
		emit_signal("damaged")


func set_health(Value: int):
	health = clamp(Value, 0, max_health)
	emit_signal("health_updated", health)
	if health == 0:
		dead_state()
		emit_signal("killed")

func add_mana(value: int):
	mana += value
	emit_signal("mana_updated", mana)
	if mana > 100:
		mana = 100

func remove_mana(value: int):
	if value > mana:
		return false 
	else:
		mana -= value
		emit_signal("mana_updated", mana)
		return true

func _on_Player_damaged():
#	PlayerSprite.visible = not PlayerSprite.visible
	if has_died == false:
		player_sprite.get_material().set_shader_param("whitening", 1)
		invisibility_timer.start()


func _on_TimeTillNextGhost_timeout():
	create_ghost()


func _on_InvisibilityTimer_timeout():
	if has_died == false:
		hurtbox_collision_shape.set_disabled(false)
		#	PlayerSprite.show()
		player_sprite.get_material().set_shader_param("whitening", 0)


#How long player dashes
func _on_DashTimer_timeout():
	player_sprite.scale = Default_Size
	dash_cool_down.start()
	SpeedMultiplier = SpeedMultiplier / 4
	self.set_collision_mask_bit(2, true)



func _on_DashCoolDown_timeout():
	can_dash = true


func _on_HurtBox_area_entered(area):
	add_mana(5)
	knockback_direction = hurtbox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED




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

func play_animation(animation_wanted_to_play):
	new_animation = animation_wanted_to_play

	if (current_animation == new_animation): return
	
	animationplayer.play(new_animation)
	
	current_animation = new_animation


func Get_References():
	player_sprite = get_node(player_sprite)
	sword = get_node(sword)
	dash_timer = get_node(dash_timer)
	health_bar = get_node(health_bar)
	health_bar_under = get_node(health_bar_under)
	health_bar_tween = get_node(health_bar_tween)
	hurtbox = get_node(hurtbox)
	animationplayer = get_node(animationplayer)
	time_till_next_ghost = get_node(time_till_next_ghost)
	invisibility_timer = get_node(invisibility_timer)
	dash_cool_down = get_node(dash_cool_down)
	shadow = get_node(shadow)
	hurtbox_collision_shape = get_node(hurtbox_collision_shape)
	collision_shape = get_node(collision_shape)
