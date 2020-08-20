extends Panel


var ItemClass = preload("res://Scenes/Item.tscn")
var item = null

func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instance()
		add_child(item)

func PickFromSlot():
	remove_child(item)
	var inventorynode = find_parent("Inventory")
	item = null

func PutIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventorynode = find_parent("Inventory")
	add_child(item)