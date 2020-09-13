extends Panel

var dragPoint


func _on_SplitBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				# Grab it.
				dragPoint = get_global_mouse_position()
			else:
				# Release it.
				dragPoint = null

	if event is InputEventMouseMotion and dragPoint != null:
		set_position(get_global_mouse_position() - dragPoint)
