extends Node

@onready var music_player = $Music
@onready var sfx_player = $SFX

var cur_music_track
var music_track_queue = []

var cur_sfx_track
var sfx_track_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
#	pick a random track for the menu
	pass # Replace with function body.


func _input(_event):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("DEBUG_Quit"):	
			get_tree().quit()
	else:
		self.set_process_input(false)


func _queue_music_track():
	pass
