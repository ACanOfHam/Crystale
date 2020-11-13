extends Node

onready var sort = get_parent().get_owner().get_node("Sort")
enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}

const valid_commands = [
#	["set_speed",
#		[ARG_INT] ],
	["quit", 
		[ARG_STRING] ], 
	["set_health",
		[ARG_INT] ],
	["set_mana",
		[ARG_INT] ],
]

func _ready():
	pass

func set_health(health):
	health = int(health)
	if health > 100:
		return str("Health must be less then ", PlayerManager.max_health)
	
	PlayerManager._set_health(health)
	return str("Successfully set health to ", health)

#func set_speed(speed):
#	speed = int(speed)
#	player.SpeedMultiplier = speed
#	return str("Successfully set speed to ", speed)

func quit(useless):
	get_parent().queue_free()
	get_tree().paused = false

func set_mana(mana):
	mana = int(mana)
	if mana > 100:
		return str("Mana must be less then 100")
	
	PlayerManager.set_mana(mana)
	return str("Successfully set mana to ", mana)
