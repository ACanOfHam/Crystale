extends Control


onready var input_box = $Input
onready var output_box = $Output
onready var command_handler = $CommandHandler

func _ready():
	input_box.grab_focus()

func output_text(text):
	output_box.text = str(output_box.text, "\n", text)

func _on_Input_text_entered(new_text):
	input_box.clear()
	process_command(new_text)

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	for i in range(words.count("")):
		words.erase("")
	
	if words.size() == 0:
		return

	var command_word = words.pop_front()

	for c in command_handler.valid_commands:
		if c[0] == command_word:
			if words.size() != c[1].size():
				output_text(str('Failure executing command "', command_word, '", expected ', c[1].size(), ' parameters'))
				return
			for i in range(words.size()):
				if not check_type(words[i], c[1][i]):
					output_text(str('Failure executing command "', command_word, '", parameter ', (i + 1),
								' ("', words[i], '") is of the wrong type'))
					return
			output_text(command_handler.callv(command_word, words))
			return
	output_text(str('Command "', command_word, '" does not exist.'))


func check_type(string , type):
	if type == command_handler.ARG_INT:
		return string.is_valid_integer()
	if type == command_handler.ARG_FLOAT:
		return string.is_valid_float()
	if type == command_handler.ARG_STRING:
		return true
	if type == command_handler.ARG_BOOL:
		return (string == "true" or string == "false")
	return false
