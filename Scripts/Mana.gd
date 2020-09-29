extends TextureProgress

var canRegen: bool = true
onready var UpdateTween: Tween = $UpdateTween

func _ready():
	self.value = 100

func _on_Player_mana_updated(mana):
	UpdateTween.interpolate_property(
		self,
		"value",
		self.value,
		mana,
		0.4,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	UpdateTween.start()
