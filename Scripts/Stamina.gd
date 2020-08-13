extends TextureProgress

var canRegen = true



func _on_Player_damaged():
	canRegen = false
	$StaminaCooldowm.start()


func _on_Player_stamina_updated(stamina):
	$UpdateTween.interpolate_property(self, "value", self.value, stamina, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT)
	$UpdateTween.start()


func _on_Stamina_Timer_timeout():
	if canRegen:
		self.value = self.value + 5
		


func _on_StaminaCooldowm_timeout():
	canRegen = true
	self.value = self.value + 5
