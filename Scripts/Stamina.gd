extends TextureProgress

var canRegen = true
onready var stamina = get_parent().get_parent().get_node("Player")


func _on_Player_stamina_updated(stamina):
	self.value = stamina
