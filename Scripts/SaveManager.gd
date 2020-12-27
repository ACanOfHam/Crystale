extends Node

signal finished_loading
signal finished_clearing
signal finished_saving

var auto_save_delay := 10

func _ready():
	auto_save()

func auto_save():
	yield(get_tree().create_timer(auto_save_delay), "timeout")
	save_game()
	auto_save()


func save_game():
	
	print("Saving")
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	
	save_game.close()
	emit_signal("finished_saving")
	return


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	
#	var load_thread = Thread.new()
#	load_thread.start(self, "load_game")
	
	print("Loading")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("No save file found")
		emit_signal("finished_loading")
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	yield(get_tree().create_timer(0.1), "timeout")
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object, true)
		if not new_object.get("position") == null: new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		new_object.add_to_group("Persist")
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	
	save_game.close()
	emit_signal("finished_loading")
	return

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_game()
