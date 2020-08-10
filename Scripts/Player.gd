extends KinematicBody2D

#Movement variable
var MAX_SPEED : int = 19000
var ACCELERATION : int  = MAX_SPEED/4
const FRICTION : int = 19000
var velocity : Vector2 
onready var canDash : bool = true
var input_vector = Vector2.ZERO
var DashMultiplier : int = 1

#References
onready var Sword = $Sword

#State Machine
var state
var CanMove : bool = true

enum {
	MOVE,
	DASH,
	DEAD,
	IDLE
}

signal health_updated(health)
signal killed()
signal damaged()

#Health Variables
export (int) var max_health = 100
onready var health = max_health setget Set_Health


func _ready():
	 $HUD/GUI/HealthBar/TextureProgress.value = max_health

#This process is called every frame and should not be used for physics
func _process(delta):
	
	#Animation Management
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state = MOVE
	else:
		state = IDLE
	
	
	#Getting Mouse Position and flipping character based on where mouse is
	var vert = get_global_mouse_position()
	var gpos = self.get_global_position()
	if gpos.x < vert.x:
		get_node("Sprite").set_flip_h(false)
		vert.x = -vert.x # Our sprite would be facing away from the mouse after flipping
	else:
		get_node("Sprite").set_flip_h(true)
		
	


#This process is called every physics frame 
func _physics_process(delta):
	
	if Input.is_action_just_pressed("dash"):
		state = DASH
	
	match state:
		DASH:
			dash_state()
		MOVE:
			move_state(delta)
		IDLE:
			idle_state()

func move_state(delta):
	$AnimationPlayer.play("Run")
	
	#Movement
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
		
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta 
		velocity = velocity.clamped(MAX_SPEED * delta) * DashMultiplier
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta )
		
	move_and_slide(velocity)



func idle_state():
	$AnimationPlayer.play("Idle")

#Function used for dashing
func dash_state():
	if canDash == true:
		canDash = false
		DashMultiplier = 4
		Create_Ghost()
		$DashTimer.start()
		$TimeTillNextGhost.start()


func dead_state():
	print("Dead!")



func Create_Ghost():
	var Ghost = preload("res://Scenes/GhostTrail.tscn").instance()
	Ghost.global_position = $Sprite.global_position
	Ghost.flip_h = $Sprite.flip_h
	Ghost.texture = $Sprite.texture
	Ghost.frame = $Sprite.frame
	Ghost.scale = $Sprite.scale
	get_tree().get_root().add_child(Ghost)

func Damage(amount):
	if $DashTimer.is_stopped():
		print(health)
		Set_Health(health - amount)
		emit_signal("damaged")


func Set_Health(Value: int):
	var prev_health = health
	health = clamp(Value, 0, max_health)
	if health != prev_health:
		$HUD/GUI/HealthBar/UpdateTween.interpolate_property($HUD/GUI/HealthBar/TextureProgress, "value", $HUD/GUI/HealthBar/TextureProgress.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
		$HUD/GUI/HealthBar/TextureProgress.value = health
		$HUD/GUI/HealthBar/UpdateTween.start()
		emit_signal("health_updated", health)
		if health == 0:
			dead_state()
			emit_signal("killed")


func _on_Player_damaged():
	$Sprite.visible = not $Sprite.visible
	$InvisibilityTimer.start()



func _on_TimeTillNextGhost_timeout():
	Create_Ghost()



func _on_InvisibilityTimer_timeout():
	$Sprite.show()


#How long player dashes
func _on_DashTimer_timeout():
	$DashCoolDown.start()
	DashMultiplier = 1

func _on_DashCoolDown_timeout():
	canDash = true




