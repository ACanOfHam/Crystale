extends Node


onready var player = get_parent().get_parent().get_parent()
onready var sort = get_parent().get_owner().get_node("Sort")
enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}

const valid_commands = [
	["set_speed",
		[ARG_INT] ],
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
	if health > player.max_health:
		return str("Health must be less then ", player.max_health)
	
	player.set_health(health)
	return str("Successfully set health to ", health)

func set_speed(speed):
	speed = int(speed)
	player.SpeedMultiplier = speed
	return str("Successfully set speed to ", speed)

func quit(useless):
	get_parent().queue_free()
	get_tree().paused = false

func set_mana(mana):
	mana = int(mana)
	if mana > 100:
		return str("Mana must be less then 100")
	
	player.mana = mana
	player.emit_signal("mana_updated", mana)
	return str("Successfully set mana to ", mana)
