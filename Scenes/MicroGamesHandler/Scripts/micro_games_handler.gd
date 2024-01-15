extends Node2D
#og colorrect pos: -108, -72
#sadly will need to do a lot of refactoring to account
#for boss microgames which won't have a timer...... that
#means that we can either USE the full screen space OR
#we can replace the debugrects with some sort of nice border
var game_state = "loss"

@onready var mcg_timer = $Timer

@onready var mcg_port = $SubViewPortContainer/SubViewPort
@onready var mcg_port_container = $SubViewPortContainer
@onready var prompt_label = $PromptLabel
var prompt_label_initial_text = "Ready?"
@onready var screen_cover = $ColorRect

@export var max_hearts : int  = 4
var num_hearts = max_hearts

@onready var bomb_timer = $BombTimer
@onready var bomb = $BombTimer/Sky/Bomb
@onready var bomb_init_pos = bomb.position
@onready var init_bomb_texture = bomb.texture
@export var bomb_explode_texture = load("res://Scenes/MicroGamesHandler/Assets/2D/EndBomb.png")

@onready var bomb_sfx = $BombSFX
@onready var bomb_bump = bomb_sfx.stream
@onready var bomb_splode = load("res://Scenes/MicroGamesHandler/Assets/Audio/BombSplode.ogg")

var microgames_dir = "res://Scenes/MicroGames/"
var all_microgames = DirAccess.get_files_at(microgames_dir)

var microgames_count = 0

var microgames_max_index = all_microgames.size() - 1

var start_game_breather_time = 3
var win_loss_time = 2

var ready_time

var debug_microgame_path = "res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn"

var cur_microgame_difficulty = "easy"

var microgame_playmode = "random_shuffle"#shuffle from queue, go through queue, etc
var microgames_pool = all_microgames

var previous_microgame
var current_microgame
var next_microgame
var microgames_queue

var speed_up_flag
var cur_game_speed = 1

signal zoom_into_microgame
signal get_input_flags
signal zoom_out_of_microgame

func _ready():
	$PromptLabel/DEBUGHearts.text = str(num_hearts)
	mcg_timer.connect("timeout", Callable(self, "on_increment_timer"))
	pick_microgame()
	#mcg_port_container.set_gui_input(false)
	#load_microgame("res://Scenes/MicroGames/PopIt.tscn")
#	load_microgame("res://Scenes/MicroGames/PetThePet.tscn")


	
#	load_microgame(debug_microgame_path)
func flash_ready():
	$PromptLabel/AnimationPlayer.play("flash_ready")
	await $PromptLabel/AnimationPlayer.animation_finished
	return

func speed_up(new_speed):
	cur_game_speed = new_speed

func update_microgame_difficulty(new_difficulty):
	cur_microgame_difficulty = new_difficulty

func pool_microgames():
#this might be replacing queue_microgames.
	pass

func queue_microgames():
	var _temp_microgames_array = []
#	temp_microgames_array

func pick_microgame():
	var my_game_index
	var my_game_path
	match microgame_playmode:
		"random_shuffle":
			my_game_index = randi_range(0, microgames_pool.size()-1)
			my_game_path = microgames_dir + microgames_pool[my_game_index]
		"shuffle":
			pass
		"queue":
			pass
	load_microgame(my_game_path)

func load_microgame(mcg):
	await flash_ready()
	ResourceLoader.load_threaded_request(mcg)
	add_and_initialize_microgame(mcg)

func add_and_initialize_microgame(mcg):
	bomb_sfx.stream = bomb_bump
	screen_cover.show()
	var microgame_scn = ResourceLoader.load_threaded_get(mcg)

	var microgame_instance = microgame_scn.instantiate()
	emit_signal("get_input_flags", microgame_instance.input_flags)
#	microgame's _init() is called here ^
	current_microgame = microgame_instance
	
	current_microgame._set_difficulty(cur_microgame_difficulty)
	
	current_microgame.connect("start_game", Callable(self, "on_start_game"))
	current_microgame.connect("end_game", Callable(self, "on_end_game"))
#	mcg_timer.connect("timeout", Callable(self, "on_increment_timer"))
	
	prompt_label.text = current_microgame._prompt
	prompt_label.show()
	
	mcg_port.add_child(current_microgame)#this needs to be at the end so that we can emit start_game in the ready function.
#	microgame's _ready() is called here ^

func on_start_game():
#	print(current_microgame.get_groups())
	emit_signal("zoom_into_microgame")
#	mcg_timer.start(start_game_breather_time)
#	await mcg_timer.timeout#this should be based on the time you want them to read the prompt
#	this part really should be in base microgame :/


#	actually you can do all of the stuff in here

func on_end_game(end_state):
	Globals.kill_sounds()
	bomb_timer.hide()
	$WinLossRect.show()
	match end_state:
		"success":
			$WinLossRect/WinLabel.show()
		"failure":
			$WinLossRect/LossLabel.show()
	update_num_hearts(end_state)
# here is where you need to await the win_time
#	current_microgame.disconnect("start_game", Callable(self, "on_start_game"))
#	current_microgame.disconnect("end_game", Callable(self, "on_end_game"))
	emit_signal("zoom_out_of_microgame")
	current_microgame.queue_free()
	microgames_count += 1
#	update the counter
	mcg_timer.start(win_loss_time)
	await mcg_timer.timeout
#	Globals.music_player.stop()
#	Globals.music_player.stream = null

	$WinLossRect.hide()
	$WinLossRect/WinLabel.hide()
	$WinLossRect/LossLabel.hide()
	
	#check game_state
	
func on_done_zoom_in():
#HERE IS WHERE WE NEED TO DEBUG!
#	from here, we await a couple seconds for the timer to run out and remove the colorrect
	mcg_timer.start(start_game_breather_time)
	await mcg_timer.timeout
	screen_cover.hide(); prompt_label.hide();prompt_label.text = prompt_label_initial_text
	#mcg_port_container.set_gui_input(true)
	if current_microgame._init_music_track:
		Globals.set_and_play_music(current_microgame._init_music_track)
	
	initialize_bomb_timer_visuals()
	
	current_microgame._start()
	mcg_timer.start(current_microgame._time_step)

func on_done_zoom_out():
	#couple things here... don't immediately pick the microgame, wait a little and also offload this to the maingame
	#second off: save the previous microgame for reference, even if only as a name
	#third off: you need to do the start_game after waiting for the game to actually ZOOM... this seems to be an issue only in pet_the_pet
#	print(current_microgame)
	pick_microgame()
	pass


func initialize_bomb_timer_visuals():
	bomb.position = bomb_init_pos
	bomb.texture = init_bomb_texture
	bomb_timer.show()


func on_increment_timer():
	if current_microgame == null:
		mcg_timer.stop()
		return
#	print(bomb.position.y)
	if bomb.texture == init_bomb_texture:
		if bomb.position.y == 150:
			current_microgame.process_toggle(false)
			#mcg_port_container.set_gui_input(false)
			bomb.texture = bomb_explode_texture
			bomb.position = Vector2(6.5 , 146.5)
			bomb_sfx.stream = bomb_splode
		else:
			bomb.position.y += 20
	else:
		current_microgame._end_game()
		bomb.texture = init_bomb_texture
	bomb_sfx.play()

func update_num_hearts(update_type):
	match update_type:
		"failure":
			num_hearts -=1
		"success":
			if num_hearts < max_hearts:
				num_hearts += 1
	if num_hearts == 0:
		pass
		#you lose!!!!
	$PromptLabel/DEBUGHearts.text = str(num_hearts)
#	for normal microgames, we'd move onto the next one (or if you lose all lives, lose)

#	for boss microgames, we'd retry until success or until we're out of lives
