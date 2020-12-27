extends ColorRect

export (NodePath) var camera_path
export(NodePath) var animation_player_path
var animation_player

var image = Image.new()
var texture = ImageTexture.new()

func _ready():
#	show()
	animation_player = get_node_or_null(animation_player_path)
	Time.connect("time_passed", self, "_time_passed")
	image.create(128, 2, false, Image.FORMAT_RGBAH)

func _physics_process(delta):
	_update_texture()
	var t = Transform2D(0, Vector2())
	var camera = get_node_or_null(camera_path)
	if camera != null:
		var canvas_transform = camera.get_canvas_transform()
		var top_left = -canvas_transform.origin / canvas_transform.get_scale()
		t = Transform2D(0, top_left)
	material.set_shader_param("global_transform", t)

func _update_texture():
	# Get all light sources in the level
	var lights = get_tree().get_nodes_in_group("lights")
	# Assign values to the texture
	image.lock()
	for i in lights.size():
		var light = lights[i]
		if light is LightSource:
			# Store the x and y position in the red and green channels
			# How luminious the light is in the blue channel
			# And the light's radius in the alpha channel
			var light_position = light.global_position.floor()
			image.set_pixel(i, 0, Color( \
					light_position.x, light_position.y, \
					light.strength, light.radius))
			# Store the light's color in the 2nd row
			image.set_pixel(i, 1, light.color)
	image.unlock()
	
	texture.create_from_image(image)
	
	material.set_shader_param("n_lights", lights.size())
	material.set_shader_param("light_data", texture)

func _time_passed(date_time):
	#Color(0, 0, 0, 0), Color(0, 0, 0, 0.862745)
	for dt in date_time:
		if dt.equals_hour(5):
			animation_player.play("SunRise")
		
		if dt.equals_hour(19):
			animation_player.play_backwards("SunRise")
			# ADD DAY AND NIGHT CYCLE NOW NERD
