extends Area2D


func damage(value: int):
	if get_parent().has_method("damage"):
		get_parent().damage(value)
	else:
		print(get_parent().get_name() + " does not have damage function")
