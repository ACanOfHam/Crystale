extends KinematicBody2D

signal health_updated(health)
signal killed()
signal damaged()

#Health Variables
export (int) var max_health = 100
onready var health = max_health setget Set_Health



func Damage(amount):
	Set_Health(health - amount)
	emit_signal("damaged")


func Set_Health(Value: int):
	var prev_health = health
	health = clamp(Value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			emit_signal("killed")

