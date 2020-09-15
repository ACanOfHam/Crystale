extends TextureProgress

var canRegen: bool = true
onready var UpdateTween: Tween = $UpdateTween

func _ready():
	self.value = get_owner().get_owner().get_node("Sort/Player").mana

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
