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

func change_sfx_volume(value: int):
	for audio_stream_player in sfx.get_children():
		audio_stream_player.volume_db = value

func change_music_volume(value: int):
	for audio_stream_player in music.get_children():
		audio_stream_player.volume_db = value
