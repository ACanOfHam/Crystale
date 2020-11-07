extends 'res://Scripts/Enemy.gd'

var flip_pos: Vector2

func _process(delta):
	
	if enemy_sprite.frame > 9 and enemy_sprite.frame < 11:
		stats.speed = 0
	else:
		stats.speed = 210
	
	
	flip_pos = move
	if flip_pos.x > 0.1 and (enemy_sprite.frame != 9 or enemy_sprite.frame != 10 or enemy_sprite.frame != 11):
		enemy_sprite.set_flip_h(false)
	elif flip_pos.x < 0.1 and (enemy_sprite.frame != 9 or enemy_sprite.frame != 10 or enemy_sprite.frame != 11):
		enemy_sprite.set_flip_h(true)
		flip_pos = -flip_pos

