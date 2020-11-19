extends KinematicBody2D

export var speed: float = 1000

onready var collision_detection = $CollisionDetection

func _ready():
	look_at(get_global_mouse_position())


func _physics_process(delta):
	position += transform.x * speed * delta
	move_and_collide(Vector2(0,0))
	if move_and_collide(Vector2(0,0)) and speed != 0:
		speed = 0
		PlayerManager.set_position(global_position)
		yield(get_tree().create_timer(0.5),"timeout")
		self.queue_free()
