extends TextureProgress

onready var HealthBarUnder = $HealthBarUnder
onready var HealthBarTween = get_parent().get_node("UpdateTween")

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.connect("health_updated", self, "_on_Player_health_updated")


func _on_Player_health_updated(healthvalue):
	HealthBarTween.interpolate_property(
		HealthBarUnder,
		"value",
		HealthBarUnder.value,
		healthvalue,
		0.4,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	self.value = healthvalue
	HealthBarTween.start()
