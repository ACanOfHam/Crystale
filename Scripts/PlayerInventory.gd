extends Node

const NUM_INVENTORY_SLOTS: int = 15

var inventory: Dictionary = {
	
}

func _ready():
	add_item('Iron Sword', 1)

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			# TODO: Check if slot is full
			inventory[item][1] += item_quantity
			return	
	
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return
