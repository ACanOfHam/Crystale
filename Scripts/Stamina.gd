extends TextureProgress

var canRegen: bool = true

func _ready():
	self.value = get_parent().get_parent().get_parent().stamina

func _on_Player_stamina_updated(stamina):
	self.value = stamina
