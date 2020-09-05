extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 400
var velocity = Vector2.ZERO
var item_name
onready var Player = get_node("/root/World/Player")

var player = null
var being_picked_up = false

func _physics_process(delta):
	if being_picked_up == true:
		var direction = global_position.direction_to(Player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(Player.global_position)
		if distance < 4:
			queue_free()
			PlayerInventory.add_item(item_name, 1)
		velocity = move_and_slide(velocity)

func _ready():
	item_name = "Mana Potion"

func pick_up_item(body):
	player = body
	being_picked_up = true
