extends Node2D

class_name microgame

var _music_track

var _time_step = 0.5

var difficulty = "easy"
var prompt = "Task!"

var end_state = "failure"#or "failure"

var game_inputs = ["ui_up", "ui_down", "ui_left", "ui_right", 
"button_0", "button_1", "mouse_touch", "microphone"]
var _disabled_inputs = ["ui_down"]

var _cur_inputs = []
#override this in order to properly 

#var _used_inputs = game_inputs - _stripped_inputs


#the base window size is 240x160, there are 12 pixels missing from left and right
#as well as 8 from top and bottom--this leaves the usable, unbordered area as
#216 x 144

signal start_game
signal end_game
signal increment_timer

#	called when the node is initialized (loaded into memory)
func _init(dif = difficulty):
#	_time_step = some_time
#	_music_track = some_music_track
#	prompt = some_prompt
#	difficulty = dif
	pass
	
#func _input(event):
#	if event is InputEventMouseButton && !event.is_echo():
#		print(event)
#	called when the node enters the scene tree for the first time
#	you shouldn't need to override this, unless you want to use
#	physics_process
func _ready():
	boilerplate_ready()

func boilerplate_ready():
	set_process(false)
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
		"boss":
			pass
#		default
		_:
			pass
			
func _set_initial_values():
	pass

#you shouldn't need to override this
func _start():
	set_process(true)
	track_time()


func track_time():
	var timer
	while self != null:
		timer = get_tree().create_timer(_time_step)
		await timer.timeout
		emit_signal("increment_timer")
#	if condition not met:
#		pass
	pass

func _end_game(state = end_state):
	emit_signal("end_game", state)
