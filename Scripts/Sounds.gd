extends Node

var sfx: Node2D
var music: Node2D

func _enter_tree():
	music = $Music
	sfx = $SFX


func playsfx(sfx_name = null):
	if sfx_name:
		sfx.Play(sfx_name)

func playmusic(music_name = null):
	if music:
		music.Play(music_name)
