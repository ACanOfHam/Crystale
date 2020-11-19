extends Node

const NUM_INVENTORY_SLOTS: int = 15


const SlotClass = preload("res://Scripts/Slot.gd")
const ItemClass = preload("res://Scripts/Item.gd")

var inventory: Dictionary = {

}

func _ready():
	add_item("Mana Potion", 2)


func remove_item_by_name(item_name, item_qt):
	for item in inventory:
		if inventory[item][0] == item_name and inventory[item][1] != 0:
			inventory[item][1] -= item_qt
			if inventory[item][1] == 0: inventory.erase(inventory[item][1])
			print(inventory)





func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonItemDb.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				return
			else:
				inventory[item][1] += able_to_add
				item_quantity = item_quantity - able_to_add

	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			return

func remove_item(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.slot_index][1] += quantity_to_add

func save():
	var save_dict = {
	"filename" : get_filename(),
	"parent" : get_parent().get_path(),
	"pos_x" : 0, # Vector2 is not supported by JSON
	"pos_y" : 0,
	"inventory": inventory
#	"level" : level,
#	"is_dead" : has_died,
	}
	return save_dict
