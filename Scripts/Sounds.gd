extends Node


var SFX
var Music 

func _enter_tree():
	Music = $Music
	SFX = $SFX

func playsfx(sfx = null):
	if sfx:
		SFX.Play(sfx)

func playmusic(music = null):
	if music:
		Music.Play(music)
