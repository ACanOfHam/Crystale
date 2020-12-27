extends CanvasLayer

var i = 0
onready var paused = $Paused
onready var texture_rect = $TextureRect
onready var animation_player = $AnimationPlayer
onready var quit_label = $Quit/QuitLabel
onready var quit_button = $Quit

#TODO: THIS IS SUCH A SHITTY WAY TO DO THIS FIX THIS NIGGA 

func _input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().has_group("World"):
		if i == 0:
			paused.visible = true
			get_tree().paused = true
			texture_rect.visible = true
			quit_button.visible = true
			i = 1
			animation_player.play("FadeIn")
		elif i == 1:
			paused.visible = false
			get_tree().paused = false
			quit_button.visible = false
			i = 0
			animation_player.play("FadeOut")

func _on_Quit_button_down():
	quit_label.set_position(Vector2(8.77, 1.5))


func _on_Quit_button_up():
	quit_label.set_position(Vector2(8.77, 0.868))


func _on_Quit_pressed():
	get_tree().quit()

func find_node_by_name(root, name):

	if(root.get_name() == name): return root

	for child in root.get_children():
		if(child.get_name() == name):
			return child

		var found = find_node_by_name(child, name)

		if(found): return found

	return null
