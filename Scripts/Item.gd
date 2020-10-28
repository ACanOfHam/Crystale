extends Node2D

var item_name: String
var item_quantity: int
onready var label: Label = $Label
onready var texture_rect: TextureRect = $TextureRect

func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "Iron Sword"
	elif rand_val == 1:
		item_name = "Bow"
	else:
		item_name = "Health Potion"

	texture_rect.texture = load("res://ArtWork/Items/" + item_name + ".png")
	var stack_size = int(JsonItemDb.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1

	if stack_size == 1:
		label.visible = false
	else:
		label.text = String(item_quantity)


func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	label.text = String(item_quantity)


func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	texture_rect.texture = load("res://ArtWork/Items/" + item_name + ".png")

	var stack_size = int(JsonItemDb.item_data[item_name]["StackSize"])
	if stack_size == 1:
		label.hide()
	else:
		label.show()
		label.text = String(item_quantity)
