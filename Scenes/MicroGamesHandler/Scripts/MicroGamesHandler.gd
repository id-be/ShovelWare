extends Node2D


@onready var mcg_port = $SubViewPortContainer/SubViewPort#find a way to find this

var microgames_dir = "res://Scenes/MicroGames/"
var all_microgames = DirAccess.get_files_at(microgames_dir)

var microgames_max_index = all_microgames.size() - 1

var tutorial_time = 3

var debug_microgame_path = "res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn"

var current_microgame
var next_microgame
var microgames_queue

signal zoom_into_microgame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


#func _input(event):
#	if Input.is_action_just_pressed("DEBUG_MOUSE"):
#		load_microgame("res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn")


func queue_microgames():
	var _temp_microgames_array = []
#	temp_microgames_array


func load_microgame(mcg):
	ResourceLoader.load_threaded_request(mcg)
#	microgame.instantiate()
#	self.add_child(microgame)
	add_and_initialize_microgame(mcg)


func add_and_initialize_microgame(mcg):
	var microgame_scn = ResourceLoader.load_threaded_get(mcg)
	var microgame = microgame_scn.instantiate()

	current_microgame = microgame
	
	current_microgame.connect("start_game", Callable(self, "on_start_game"))
	current_microgame.connect("end_game", Callable(self, "on_end_game"))
	
	mcg_port.add_child(current_microgame)#this needs to be at the end so that we can emit start_game in the ready function.


func on_start_game():
#	current_microgame.set_process(false)
#	current_microgame.set_process_input(false)
#	current_microgame.set_process_unhandled_input(false)

	emit_signal("zoom_into_microgame")

	await get_tree().create_timer(tutorial_time).timeout

#	actually you can do all of the stuff in here


func on_end_game(end_state):
	print(end_state)
	get_tree().paused = true
	$WinLossRect.show()
	match end_state:
		"success":
			$WinLossRect/WinLabel.show()
		"failure":
			$WinLossRect/LossLabel.show()
	await get_tree().create_timer(2).timeout
	current_microgame.queue_free()
	$WinLossRect.hide()
	$WinLossRect/WinLabel.hide()
	$WinLossRect/LossLabel.hide()
