extends 'res://Scripts/Enemy.gd'

var flip_pos: Vector2
var can_flip: bool = true
var can_change_direction: bool = true

func _ready():
	animationplayer.play("Idle")


func _process(delta):
	can_change_direction = true
	
	if enemy_sprite.frame > 7:
		stats.speed = 0
		can_flip = false
		can_change_direction = true
	else:
		can_flip = true
		stats.speed = 210
		can_change_direction = false
	
	
	flip_pos = move
	if flip_pos.x > 0.1 and can_flip != false:
		enemy_sprite.set_flip_h(false)
	elif flip_pos.x < 0.1 and can_flip != false:
		enemy_sprite.set_flip_h(true)
		flip_pos = -flip_pos

func move_state(delta):
	var old_move = move
	if player == null: player = get_parent().get_node("Player")
	animationplayer.play("Move")
	move = (player.global_position - global_position).normalized() * stats.speed
	print(old_move)
	if can_change_direction == false and old_move != Vector2.ZERO: move = old_move.normalized() * stats.speed
	move = move_and_slide(move) * stats.speed * delta
