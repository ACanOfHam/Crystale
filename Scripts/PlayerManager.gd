extends Node2D

var player

onready var health : int = 100
onready var mana : int = 100

signal health_updated(health)
signal mana_updated(mana)


func _ready():
	SceneChanger.connect("scene_changed",self, "scene_changed")

func _physics_process(delta):
	if player == null: player = get_tree().get_root().find_node("Player", true, false)

func scene_changed():
	player = get_tree().get_root().find_node("Player", true, false)

func _set_health(value: int):
	player.health = value
	emit_signal("health_updated", player.health)

func set_health(value):
	if value < 0:
		player.health = player.health + value
		Sounds.playsfx("Hurt")
		emit_signal("damaged")
		if player.health <= 0:
			SceneChanger.change_scene("DeadScreen")
	else:
		player.health = player.health + value
	emit_signal("health_updated", player.health)


func set_mana(value: int):
	player.mana = player.mana + value
	
	emit_signal("mana_updated", player.mana)

func set_position(position_to_set: Vector2):
	player.global_position = position_to_set

func get_position():
	return player.global_position

func get_camera():
	while player == null:
		if player != null:
			return player.camera
