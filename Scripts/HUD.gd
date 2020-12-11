extends CanvasLayer

var isInventory : bool


func _unhandled_input(event):
	if event.is_action_pressed("Inventory"):
		$Inventory.initialize_inventory()
		$Inventory.visible = !$Inventory.visible
		if $Inventory.visible == false:
			Engine.time_scale = 1
			if get_parent().get_node("Sword") != null:
				get_parent().get_node("Sword").canPlaySFX = true
		else:
			Engine.time_scale = 0.2
			if get_parent().get_node("Sword") != null:
				get_parent().get_node("Sword").canPlaySFX = false

