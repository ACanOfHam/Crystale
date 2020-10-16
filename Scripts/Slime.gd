extends 'res://Scripts/Enemy.gd'

var flip_pos: Vector2

func _process(delta):
	flip_pos = move
	if flip_pos.x > 0.1:
		enemy_sprite.set_flip_h(false)
	else:
		enemy_sprite.set_flip_h(true)
		flip_pos = -flip_pos

