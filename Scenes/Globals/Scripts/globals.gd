extends Node

@onready var music_player = $Music
@onready var sfx_player = $SFX

@onready var stings = [
	load("res://Scenes/MainGame/Assets/Sound/Ready.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Ready2.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Ominous.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/ULose.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Win2.ogg")
]

var cur_music_track_pos
var music_track_queue = []

var cur_sfx_track_pos
var sfx_track_queue = []


# Called when the node enters the scene tree for the first time.
func _ready():
#	print(AudioServer.bus_count)
#	AudioServer.playback_speed_scale
#	print(AudioServer.get_bus_name(3))
#	print(AudioServer.get_bus_channels(3))
#	AudioServer.get_bus_channels()

#	pick a random track for the menu
	pass # Replace with function body.

func _create_microgames_input_array():
	pass

func _input(_event):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("DEBUG_Quit"):	
			get_tree().quit()
	else:
		self.set_process_input(false)

func _queue_music_track():
	pass
func set_music_track(track):
	music_player.set_stream(track)
func play_music():
	music_player.play()
func stop_music():
	music_player.stop()
	pass
func set_and_play_music(track):
	set_music_track(track)
	play_music()
func _on_music_finished():
	music_player.stream = null
func toggle_music():
	music_player.stream_paused = !music_player.stream_paused

func _queue_sfx_track():
	pass
func set_sfx_track(track):
	sfx_player.set_stream(track)
func play_sfx():
	sfx_player.play()
func stop_sfx():
	sfx_player.stop()
func set_and_play_sfx(track):
	set_sfx_track(track)
	play_sfx()
func _on_sfx_finished():
	sfx_player.stream = null
func toggle_sfx():
	sfx_player.stream_paused = !sfx_player.stream_paused

func toggle_sounds():
	toggle_music()
	toggle_sfx()
#basically, if they're playing you want to pause them and save the current
#playback position then if they're not playing and we hit toggle sound, we 
#want to resume playing from the spot we stopped at.
	pass
func kill_sounds():
	stop_music()
	stop_sfx()
