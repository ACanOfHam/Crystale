extends Node2D

func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://ArtWork/Items/Iron_Sword.png")
	else:
		$TextureRect.texture = load("res://ArtWork/Items/Gold_Sword.png")
