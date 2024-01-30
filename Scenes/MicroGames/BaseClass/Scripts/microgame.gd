extends Node2D

#the base window size is 240x160, there are 12 pixels missing
#from left and right as well as 8 from top and bottom--this
#leaves the usable, unbordered area as 216 x 144.
#this is a 216:144 = 1.5 = 3:2 aspect ratio

class_name microgame

@export var _prompt: String = "Task!"

@export var input_flags: Dictionary = {"ui_up":false, "ui_down":false, 
"ui_left":false, "ui_right":false, "button_0":false, 
"button_1":false, "mouse_touch":false, "microphone":false}

@export var _music_tracks: Array[AudioStream]
@onready var _init_music_track = _music_tracks[0]
@export var _sfx: Array[AudioStream]

#setting difficulty here, or in the inspector, intentionally 
#does nothing. the design goal is to set all of that up
#so that the microgameshandler ramps up or lowers difficulty
#based on game state.
@export_enum("easy", "medium", "hard") var difficulty: String = "easy"
@onready var timer = Timer.new()
@export_range(0.1, 1) var _time_step: float = 0.5

@export_enum("failure", "success", "boss_failure", "boss_success") var default_end_state: String = "failure"
@onready var end_state = default_end_state

signal start_game
signal end_game
signal increment_timer

#	called when the node is initialized (loaded into memory)
func _init():
#	only use this for stuff that doesn't need to be loaded.
#	anything set in the editor is unavailable here 
#	(eg, _music_tracks) until the ready function is called 
#	(which is ALWAYS after _init).
	pass
	
func _ready():
	boilerplate_ready()

func boilerplate_ready():
	add_child(timer)
	process_toggle(false)
	_set_initial_values()
	emit_signal("start_game")

func _set_difficulty(dif):
	match dif:
		"easy":
			pass
		"medium":
			pass
		"hard":
			pass
#		default
		_:
			pass
			
func _set_initial_values():
	pass

#you shouldn't need to override this
func _start():
	boiler_plate_start()

func process_toggle(state):
	set_process(state)
	set_physics_process(state)
	set_process_input(state)
	set_process_unhandled_input(state)

func boiler_plate_start():
	process_toggle(true)

func track_time():
	timer.wait_time = _time_step; timer.start()
	await timer.timeout
	emit_signal("increment_timer")
	track_time()

func _end_game(state = end_state):
	emit_signal("end_game", state)
