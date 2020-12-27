extends MainLoop

var time_elapsed = 0
var keys_typed = []
var quit = false

func _initialize():
	print("Initialized:")
	print("  Starting time: %s" % str(time_elapsed))
