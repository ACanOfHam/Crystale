extends Area2D

export var DamageNeededToDie : int 
var DamageTaken : int 
var TotalDamageTaken : int
onready var SwordFrame = get_node("/root/World/Player/Sword/Sprite")
export var MonsterDamage = 10
var rng = RandomNumberGenerator.new()

func _on_HitBox_area_entered(area):
	
	
	match SwordFrame.frame:
		8:
			DamageTaken = 15 * rng.randf_range(1.0, 1.25)
		9:
			DamageTaken = 25 * rng.randf_range(1.0, 1.25)
		10:
			DamageTaken = 35 * rng.randf_range(1.0, 1.25)
		11:
			DamageTaken = 40 * rng.randf_range(1.0, 1.25)
		13:
			DamageTaken = 60 * rng.randf_range(1.0, 1.25)
		_:
			DamageTaken = MonsterDamage * rng.randf_range(1.0, 1.25)
	
	
	TotalDamageTaken = TotalDamageTaken + DamageTaken
	
	if TotalDamageTaken  >= DamageNeededToDie:
		queue_free()
		
	
