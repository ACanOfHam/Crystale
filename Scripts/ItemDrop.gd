extends KinematicBody2D

const ACCELERATION: int = 3000
const MAX_SPEED: int = 500
var velocity: Vector2 = Vector2.ZERO
var item_name: String

var player = null
var being_picked_up = false
var is_dead = false

func _ready():
	$Sprite.texture = load("res://ArtWork/Items/" + item_name + ".png")
	yield(get_tree().create_timer(30), "timeout")
	queue_free()
	is_dead == true


func _physics_process(delta):
	if is_dead == true: queue_free()
	
	if being_picked_up == true:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 20:
			Sounds.playsfx("Pickup")
			queue_free()
			is_dead = true
			PlayerInventory.add_item(item_name, 1)
		velocity = move_and_slide(velocity)



func pick_up_item(body):
	player = body
	being_picked_up = true

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"is_dead" : is_dead
	}
	return save_dict
