extends TextureProgress

var canRegen = true
onready var stamina = get_parent().get_parent().get_parent().stamina


func _process(delta):
	stamina = get_node("/root/World/Player").stamina
	self.value = stamina

func _on_Player_damaged():
	canRegen = false
	$StaminaCooldowm.start()

