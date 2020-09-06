extends CanvasLayer

var isInInventory

func _ready():
	get_parent().get_node("Sword").canPlaySFX = true

func _input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.initialize_inventory()
		$Inventory.visible = !$Inventory.visible
		if $Inventory.visible == false:
			get_parent().get_node("Sword").canPlaySFX = true
		else:
			get_parent().get_node("Sword").canPlaySFX = false

