extends TextureProgress

onready var HealthBarUnder = $HealthBarUnder
onready var HealthBarTween = get_parent().get_node("UpdateTween")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = 100
	HealthBarUnder.value = 100


func _on_Player_health_updated(health):
	HealthBarTween.interpolate_property(
		HealthBarUnder,
		"value",
		HealthBarUnder.value,
		health,
		0.4,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	self.value = health
	HealthBarTween.start()
