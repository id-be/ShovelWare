extends Node2D


@onready var mcg_port = $SubViewPortContainer/SubViewPort#find a way to find this
@onready var prompt_label = $PromptLabel
@onready var screen_cover = $ColorRect

@onready var game_timer = $BombTimer
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

var tutorial_time = 3
var win_loss_time = 2

var ready_time

var debug_microgame_path = "res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn"

var cur_microgame_difficulty = "easy"

var microgame_playmode = "shuffle"
var microgames_pool

var current_microgame
var next_microgame
var microgames_queue

var speed_up_flag
var cur_game_speed = 1

signal zoom_into_microgame
signal zoom_out_of_microgame

func _ready():
	load_microgame("res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn")
func flash_ready():
	$PromptLabel/AnimationPlayer.play("flash_ready")
	await $PromptLabel/AnimationPlayer.animation_finished
	return

func speed_up(new_speed):
	cur_game_speed = new_speed
	pass

func update_microgame_difficulty(new_difficulty):
	cur_microgame_difficulty = new_difficulty

func queue_microgames():
	var _temp_microgames_array = []
#	temp_microgames_array

func load_microgame(mcg):
	await flash_ready()
	ResourceLoader.load_threaded_request(mcg)
	add_and_initialize_microgame(mcg)

func add_and_initialize_microgame(mcg):
	bomb_sfx.stream = bomb_bump
	screen_cover.show()
	var microgame_scn = ResourceLoader.load_threaded_get(mcg)

	var microgame_instance = microgame_scn.instantiate()
#	microgame's _init() is called here ^
	current_microgame = microgame_instance
	
	current_microgame._set_difficulty(cur_microgame_difficulty)
	
	current_microgame.connect("start_game", Callable(self, "on_start_game"))
	current_microgame.connect("end_game", Callable(self, "on_end_game"))
	current_microgame.connect("increment_timer", Callable(self, "on_increment_timer"))
	
	prompt_label.text = current_microgame.prompt
	prompt_label.show()
	
	mcg_port.add_child(current_microgame)#this needs to be at the end so that we can emit start_game in the ready function.
#	microgame's _ready() is called here ^

func on_start_game():
	current_microgame.set_process(false)#may not need this line... just do it in the microgame
	
#	print(current_microgame.get_groups())
	emit_signal("zoom_into_microgame")
	
#	set_process(false)
	await get_tree().create_timer(tutorial_time).timeout#this should be based on the time you want them to read the prompt
#	set_process(true)
	
	Globals.set_and_play_music(current_microgame._music_track)
	
	screen_cover.hide()
	prompt_label.hide()
	initialize_game_timer()
	
	current_microgame._start()
#	actually you can do all of the stuff in here

func on_end_game(end_state):
	game_timer.hide()
	$WinLossRect.show()
	match end_state:
		"success":
			$WinLossRect/WinLabel.show()
		"failure":
			$WinLossRect/LossLabel.show()
# here is where you need to await the win_time
	emit_signal("zoom_out_of_microgame")
	current_microgame.queue_free()
	microgames_count += 1
#	update the counter
	await get_tree().create_timer(win_loss_time).timeout

#	Globals.music_player.stop()
#	Globals.music_player.stream = null

	$WinLossRect.hide()
	$WinLossRect/WinLabel.hide()
	$WinLossRect/LossLabel.hide()


func initialize_game_timer():
	bomb.position = bomb_init_pos
	bomb.texture = init_bomb_texture
	game_timer.show()


func on_increment_timer():
#	print(bomb.position.y)
	if bomb.texture == init_bomb_texture:
		if bomb.position.y == 150:
			current_microgame.set_process(false)
			bomb.texture = bomb_explode_texture
			bomb.position = Vector2(6.5 , 146.5)
			bomb_sfx.stream = bomb_splode
		else:
			bomb.position.y += 20
	else:
		current_microgame._end_game()
	bomb_sfx.play()

#	for normal microgames, we'd move onto the next one (or if you lose all lives, lose)

#	for boss microgames, we'd retry until success or until we're out of lives
