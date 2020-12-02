extends KinematicBody2D

#Preloads
var teleportation_crystal = preload("res://Scenes/Teleportation Crystal.tscn")


#Movement variable
var MAX_SPEED: int = 90000
var ACCELERATION: int = MAX_SPEED / 4
const FRICTION: int = 90000
var velocity: Vector2
onready var can_dash: bool = true
var input_vector: Vector2 = Vector2.ZERO
var speed_multiplier: int = 1
onready var default_size = $Sprite.scale
onready var mana: int = 100
var can_regen: bool = true
var knockback: Vector2 = Vector2.ZERO
const KNOCKBACK_SPEED: int = 295
const KNOCKBACK_FRICTION: int = 350
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_velocity: Vector2 = Vector2.ZERO


#References
onready var pickup_zone = $PickupZone
onready var dash_cool_down = $DashCoolDown
onready var invisibility_timer = $InvisibilityTimer
onready var time_till_next_ghost = $TimeTillNextGhost
onready var sword: Area2D = $Sword
#export (NodePath) onready var sword
onready var player_sprite: Sprite = $Sprite
#export (NodePath) onready var player_sprite
onready var dash_timer: Timer = $DashTimer
#export (NodePath) onready var dash_timer
onready var health_bar: TextureProgress = $HUD/GUI/HealthBar/TextureProgress
#export (NodePath) onready var health_bar
onready var health_bar_under: TextureProgress = $HUD/GUI/HealthBar/TextureProgress/TextureProgress_Under
#export (NodePath) onready var health_bar_under
onready var health_bar_tween: Tween = $HUD/GUI/HealthBar/UpdateTween
#export (NodePath) onready var health_bar_tween
onready var hurtbox: Area2D = $HurtBox
#export (NodePath) onready var hurtbox
onready var animationplayer: AnimationPlayer = $AnimationPlayer
#export (NodePath) onready var animationplayer
#onready var TimeTillNextGhost: Timer = $TimeTillNextGhost
#export (NodePath) onready var time_till_next_ghost
#export (NodePath) onready var invisibility_timer
onready var dash_cool_Down: Timer = $DashCoolDown
#export (NodePath) onready var dash_cool_down
onready var shadow: Sprite = $Shadow
#export (NodePath) onready var shadow
onready var hurtbox_collision_shape = $HurtBox/CollisionShape2D
onready var collision_shape = $CollisionShape2D

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

#Health Variables
export (int) var max_health = 100
onready var health: int = max_health

#Animation Variables
var stretch_finished = true
var current_animation
var new_animation

func _ready():
#	Get_References()
	PlayerManager.emit_signal("health_updated", health)
	PlayerManager.emit_signal("mana_updated", mana)

#This process is called every frame and should not be used for physics
func _process(delta):
	input_managment()
	sprite_flip()


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


func _input(event):
	if event.is_action_pressed("pickup"):
		if pickup_zone.items_in_range.size() > 0:
			var pickup_item = pickup_zone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			pickup_zone.items_in_range.erase(pickup_item)


func _on_HurtBox_area_entered(area):
	PlayerManager.set_mana(+5)
	knockback_direction = hurtbox.global_position - area.global_position
	knockback_direction = knockback_direction.normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_SPEED
	player_sprite.get_material().set_shader_param("whitening", 1)
	yield(get_tree().create_timer(0.035),"timeout")
	player_sprite.get_material().set_shader_param("whitening", 0)


func move_state(delta):
	play_animation("Run")

	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if speed_multiplier < 1 and speed_multiplier != 0:
			speed_multiplier = 1
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta) * speed_multiplier
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide(velocity)
	velocity = Vector2.ZERO


func idle_state():
	play_animation("Idle")


#Function used for dashing
func dash_state():
	if can_dash == true and mana > 20:
			PlayerManager.set_mana(-20)
			self.set_collision_mask_bit(2, false)
			Sounds.playsfx("Dash")
			can_dash = false
			speed_multiplier = speed_multiplier * 4
			create_ghost()
			yield(get_tree().create_timer(0.15),"timeout")
			create_ghost()
			player_sprite.scale = default_size
			speed_multiplier = speed_multiplier / 4
			self.set_collision_mask_bit(2, true)
			yield(get_tree().create_timer(0.1),"timeout")
			can_dash = true


func dead_state():
	has_died = true
	SceneChanger.change_scene("DeadScreen")
	for node in self.get_children():
		if node.has_method("hide"):
			node.hide()


func input_managment():
	
	if has_died == true: return
	
	#State Management
	if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")):
		state = MOVE
	else:
		state = IDLE

	#Toggle Console
	if Input.is_action_just_pressed("toggle_console"):
		self.add_child(load("res://Scenes/Console.tscn").instance())
		get_tree().paused = true
	
	if Input.is_action_just_pressed("Spawn Crystal(Temp)"):
		var teleporation_crystal_instance = teleportation_crystal.instance()
		teleporation_crystal_instance.transform = transform
		teleporation_crystal_instance.position = Vector2(global_position.x + 5, global_position.y + -20)
		get_parent().get_parent().get_parent().add_child(teleporation_crystal_instance, true)


func sprite_flip():

	if has_died == true: return

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


func create_ghost():
	var ghost = preload("res://Scenes/GhostTrail.tscn").instance()
	ghost.global_position = player_sprite.global_position
	ghost.flip_h = player_sprite.flip_h
	ghost.texture = player_sprite.texture
	ghost.frame = player_sprite.frame
	ghost.scale = player_sprite.scale
	get_tree().get_root().add_child(ghost)


func play_animation(animation_wanted_to_play):
	new_animation = animation_wanted_to_play
	
	if (current_animation == new_animation): return
	
	animationplayer.play(new_animation)
	
	current_animation = new_animation


#func Get_References():
#	player_sprite = get_node(player_sprite)
#	sword = get_node(sword)
#	dash_timer = get_node(dash_timer)
#	health_bar = get_node(health_bar)
#	health_bar_under = get_node(health_bar_under)
#	health_bar_tween = get_node(health_bar_tween)
#	hurtbox = get_node(hurtbox)
#	animationplayer = get_node(animationplayer)
#	time_till_next_ghost = get_node(time_till_next_ghost)
#	invisibility_timer = get_node(invisibility_timer)
#	dash_cool_down = get_node(dash_cool_down)
#	shadow = get_node(shadow)
#	hurtbox_collision_shape = get_node(hurtbox_collision_shape)
#	collision_shape = get_node(collision_shape)

func save():
	var save_dict = {
	"filename" : get_filename(),
	"parent" : get_parent().get_path(),
	"pos_x" : position.x, # Vector2 is not supported by JSON
	"pos_y" : position.y,
	"current_health" : health,
	"max_health" : max_health,
#	"level" : level,
#	"is_dead" : has_died,
	}
	return save_dict
