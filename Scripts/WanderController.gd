extends Node2D

export(int) var WanderRange = 32

onready var StartPosition = global_position
onready var TargetPosition = global_position

onready var WanderTimer = $WanderTimer

func UpdateTargetPosition():
	var TargetVector = Vector2(rand_range(-WanderRange, WanderRange), rand_range(-WanderRange,WanderRange))
	TargetPosition = StartPosition + TargetVector

func _on_WanderTimer_timeout():
	UpdateTargetPosition()

func GetTimeLeft():
	return WanderTimer.time_left

func StartWanderTimer(duration):
	WanderTimer.start(duration)
