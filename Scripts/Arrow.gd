extends KinematicBody2D


export var speed: float = 1000
var move
var enemy
var player

func _ready():
	look_at(get_global_mouse_position())
	yield(get_tree().create_timer(7.5),"timeout")
	self.queue_free()

func _physics_process(delta):
#	player = get_node("OverWorld/Sort/Player")
#	enemy = get_node("OverWorld/Sort/Slime")
	position += transform.x * speed * delta
#	var pos = self.get_position()
#	pos += Vector2(cos(player.sword.rotation_degrees) * speed * delta, sin(player.sword.rotation_degrees) * speed * delta)
	


func _on_HitBox_area_entered(area):
	if area.has_method("damage"):
		area.damage(15)
		queue_free()
