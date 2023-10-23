extends microgame

@export var bgs = []
@onready var bg = $TextureRect


func _init(dif = difficulty):
	_time_step = 0.4
	_music_track = load("res://Scenes/MicroGames/ExampleMicroGame/Assets/Audio/DebugTrack.ogg")
	prompt = "Pet!"
	difficulty = dif

func _ready():
	boilerplate_ready()
	
	var my_bg = randi_range(0, bgs.size()-1)
	bg.set_texture(bgs[my_bg])
	pass # Replace with function body.
func _set_difficulty(dif):
	match dif:
		"easy":
			pass
		"medium":
			pass
		"hard":
			pass
func _set_initial_values():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func animate_pet():
	pass
