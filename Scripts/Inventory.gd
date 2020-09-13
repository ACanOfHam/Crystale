extends Node2D

const SlotClass: Script = preload("res://Scripts/Slot.gd")
onready var inventory_slots: GridContainer = $TextureRect/GridContainer
var holding_item = null

func _ready():
	initialize_inventory()
	for inv_slot in inventory_slots.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding an Item
			if holding_item != null:
				# Empty slot
				if !slot.item:
					slot.PutIntoSlot(holding_item)
					holding_item = null
				# Slot already contains an item	
				else:
					# Different item, so swap
					if holding_item.item_name != slot.item.item_name:
						var temp_item = slot.item
						slot.PickFromSlot()
						temp_item.global_position = event.global_position
						slot.PutIntoSlot(holding_item)
						holding_item = temp_item
					# Same item, so try to merge
					else:
						var stack_size = int(JsonItemDb.item_data[slot.item.item_name]["StackSize"])
						var able_to_add = stack_size - slot.item.item_quantity
						if able_to_add >= holding_item.item_quantity:
							slot.item.add_item_quantity(holding_item.item_quantity)
							holding_item.queue_free()
							holding_item = null
						else:
							slot.item.add_item_quantity(able_to_add)
							holding_item.decrease_item_quantity(able_to_add)
			# Not holding an item				
			elif slot.item:
				holding_item = slot.item
				slot.PickFromSlot()
				holding_item.global_position = get_global_mouse_position()
				
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
