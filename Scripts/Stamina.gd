extends TextureProgress

var canRegen = true



func _on_Player_damaged():
	canRegen = false
	$StaminaCooldowm.start()


func _on_Player_stamina_updated(stamina):
	self.value = stamina


func _on_Stamina_Timer_timeout():
	if canRegen:
		self.value = self.value + 2


func _on_StaminaCooldowm_timeout():
	canRegen = true
	self.value = self.value + 2
