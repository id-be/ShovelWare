extends Node2D


@onready var mcg_port = $SubViewPortContainer/SubViewPort#find a way to find this

var microgames_dir = "res://Scenes/MicroGames/"
var all_microgames = DirAccess.get_files_at(microgames_dir)

var microgames_max_index = all_microgames.size() - 1

var current_microgame
var next_microgame
var microgames_queue


# Called when the node enters the scene tree for the first time.
func _ready():
	
#	var my_path = microgames_dir + all_microgames[microgames_max_index]
	var my_path = "res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn"
	
	load_microgame(my_path)


func queue_microgames():
	var _temp_microgames_array = []
#	temp_microgames_array
	pass


func load_microgame(mcg):
	ResourceLoader.load_threaded_request(mcg)
#	microgame.instantiate()
#	self.add_child(microgame)
	add_and_initialize_microgame(mcg)


func add_and_initialize_microgame(mcg):
	var microgame_scn = ResourceLoader.load_threaded_get(mcg)
	var microgame = microgame_scn.instantiate()
	mcg_port.add_child(microgame)
	current_microgame = microgame
	current_microgame.connect("end_game", Callable(self, "on_end_game"))


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
