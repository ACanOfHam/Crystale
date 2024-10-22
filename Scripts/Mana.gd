extends TextureProgress

var can_regen: bool = true
onready var update_tween: Tween = $UpdateTween

func _ready():
	PlayerManager.connect("mana_updated", self, "_on_Player_mana_updated")

func _on_Player_mana_updated(mana):
	update_tween.interpolate_property(
		self,
		"value",
		self.value,
		mana,
		0.4,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	update_tween.start()
