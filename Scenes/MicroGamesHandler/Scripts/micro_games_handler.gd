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
@onready var screen_fx = $ColorRect2
@export var tv_shader : ShaderMaterial

@export var max_hearts : int  = 4
var num_hearts = max_hearts

@onready var bomb_timer = $BombTimer
@onready var bomb = $BombTimer/Sky/Bomb
@onready var bomb_init_pos = bomb.position
@onready var init_bomb_texture = bomb.texture
@export var bomb_explode_texture : CompressedTexture2D

@onready var bomb_sfx = $BombSFX
@onready var bomb_bump = bomb_sfx.stream
@export var bomb_splode : AudioStreamOggVorbis

var microgames_dir = "res://Scenes/MicroGames/"
var all_microgames = DirAccess.get_files_at(microgames_dir)

var microgames_count = 0
var prev_microgames_count = microgames_count

var microgames_max_index = all_microgames.size() - 1

var start_game_breather_time = 3
var win_loss_time = 2

var ready_time

var debug_microgame_path = "res://Scenes/MicroGames/ExampleMicroGame/ExampleMicroGame.tscn"

@export_enum("easy", "medium", "hard") var cur_microgame_difficulty : String = "easy"

@export_enum("random_shuffle", "shuffle", "queue", "boss_queue") var microgame_playmode: String = "random_shuffle"#shuffle from queue, go through queue, etc
var microgames_pool = all_microgames

var previous_microgame
var current_microgame
var next_microgame
@export var microgames_queue: Array[String]
@export var boss_microgames_queue: Array[String]
var mcg_index_in_queue = 0

@export var mcg_count_to_gen_boss = 8#every n, you get a boss mcg. 
#this will be handled differently in that you have to win or 
#else it keeps rerolling, and after this one ends you hit a speed up
var is_cur_mcg_boss = false

signal screen_fx_toggled

signal zoom_into_microgame
signal get_input_flags
signal zoom_out_of_microgame

func _ready():
	$PromptLabel/DEBUGHearts.text = str(num_hearts)
	mcg_timer.connect("timeout", Callable(self, "on_increment_timer"))
	
	toggle_prompts()
#	screen_fx_toggle()
#	pick_microgame()
#	pick_microgame(true)

func toggle_tv_shader():
	if screen_fx.material == null:
		screen_fx.material = tv_shader
	else:
		screen_fx.material = null

func screen_fx_toggle():
	var tween
	tween = get_tree().create_tween()
	#tween.set_parallel(true)
	#tween.tween_property($Camera2D, "position", $MicroGamesHandler.position, 0.01)
##	tween.tween_property($Camera2D, "zoom", Vector2(2.25, 2.25), 0.5)
	#tween.tween_property($Camera2D, "zoom", Vector2(1.35, 1.35), 0.5)
#	print(screen_fx.scale)
	screen_fx.show()
	match screen_fx.scale:
		Vector2(1,1):
			screen_fx.scale = Vector2(1,1)
			toggle_tv_shader()

			tween.tween_property(screen_fx, "scale", Vector2(0.8, 0.1), 0.1)
			tween.tween_property(screen_fx, "scale", Vector2(0, 0), 0.1)
			await tween.finished; toggle_tv_shader()
			Globals.set_and_play_sfx(Globals.stings[5])

#			screen_fx.size = Vector2(0,0)
		Vector2(0.00001, 0.00001):#i have no clue why we can't get this to 0.
			tween.tween_property(screen_fx, "scale", Vector2(0.8, 0.1), 0.1)
			toggle_tv_shader()
			tween.tween_property(screen_fx, "scale", Vector2(1,1), 0.1)
			screen_fx.size = Vector2(240,160)
			Globals.set_and_play_sfx(Globals.stings[5])
			await tween.finished; await get_tree().create_timer(1.0).timeout
		Vector2(0.0, 0.0):#just in case this fucking bug gets fixed
			tween.tween_property(screen_fx, "scale", Vector2(0.8, 0.1), 0.1)
			toggle_tv_shader()
			tween.tween_property(screen_fx, "scale", Vector2(1,1), 0.1)
			screen_fx.size = Vector2(240,160)
			Globals.set_and_play_sfx(Globals.stings[5])
			await tween.finished; await get_tree().create_timer(1.0).timeout
	screen_fx.hide()		
	emit_signal("screen_fx_toggled")
	#match screen_fx.scale:
		#Vector2(240,160):
			#tween.tween_property(screen_fx, "size", Vector2(192, 16), 0.1)
			#tween.tween_property(screen_fx, "size", Vector2(0, 0), 0.1)
		#Vector2(0, 0):
			#tween.tween_property(screen_fx, "size", Vector2(0.8, 0.1), 0.1)
			#tween.tween_property(screen_fx, "size", Vector2(1,1), 0.1)
	#print(screen_fx.size)
	
func toggle_prompts():
	prompt_label.visible = !prompt_label.visible

func flash_ready():
	$PromptLabel/AnimationPlayer.play("flash_ready")
	await $PromptLabel/AnimationPlayer.animation_finished
	return


func update_microgame_difficulty(new_difficulty):
	cur_microgame_difficulty = new_difficulty

func pool_microgames():
#this might be replacing queue_microgames.
	pass

func queue_microgames():
	var _temp_microgames_array = []
#	temp_microgames_array

func pick_microgame(is_boss = false):
	is_cur_mcg_boss = is_boss
	if microgame_playmode == "boss_queue":
		is_cur_mcg_boss = true
	var my_game_index
	var my_game_path
	match microgame_playmode:
		"random_shuffle":
			my_game_index = randi_range(0, microgames_pool.size()-1)
			my_game_path = microgames_dir + microgames_pool[my_game_index]
		"shuffle":
			pass
		"queue":
			for mcg in microgames_queue:
				my_game_path = microgames_queue[mcg_index_in_queue]
				if mcg_index_in_queue == microgames_queue.size() - 1:
					pass
				else:
					mcg_index_in_queue +=1
		"boss_queue":
			for mcg in boss_microgames_queue:
				my_game_path = boss_microgames_queue[mcg_index_in_queue]
				if mcg_index_in_queue == boss_microgames_queue.size() - 1:
					pass
				else:
					if prev_microgames_count != microgames_count:
						mcg_index_in_queue +=1
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
	
	current_microgame._set_boss(is_cur_mcg_boss)
	current_microgame._set_difficulty(cur_microgame_difficulty)
	
	current_microgame.connect("start_game", Callable(self, "on_start_game"))
	current_microgame.connect("end_game", Callable(self, "on_end_game"))
#	mcg_timer.connect("timeout", Callable(self, "on_increment_timer"))
	
	prompt_label.text = current_microgame._prompt
	prompt_label.show()
	
	mcg_port.add_child(current_microgame)#this needs to be at the end so that we can emit start_game in the ready function.
#	microgame's _ready() is called here ^

func on_start_game():
	emit_signal("zoom_into_microgame")
#	mcg_timer.start(start_game_breather_time)
#	await mcg_timer.timeout#this should be based on the time you want them to read the prompt
#	this part really should be in base microgame :/


#	actually you can do all of the stuff in here

func on_end_game(end_state):
	Globals.kill_sounds()
	bomb_timer.hide()
	$WinLossRect.show()
	prev_microgames_count = microgames_count
	match end_state:
		"success":
			$WinLossRect/WinLabel.show()
			microgames_count += 1
		"failure":
			$WinLossRect/LossLabel.show()
			microgames_count += 1
		"boss_success":
			$WinLossRect/WinLabel.show()
			microgames_count += 1
		"boss_failure":
			$WinLossRect/LossLabel.show()
	update_num_hearts(end_state)
# here is where you need to await the win_time
#	current_microgame.disconnect("start_game", Callable(self, "on_start_game"))
#	current_microgame.disconnect("end_game", Callable(self, "on_end_game"))
	emit_signal("zoom_out_of_microgame")
	current_microgame.queue_free()

	$PromptLabel/DEBUGMCGCount.text = str(microgames_count)
#	update the counter
	mcg_timer.start(win_loss_time)
	await mcg_timer.timeout
#	Globals.music_player.stop()
#	Globals.music_player.stream = null

	$WinLossRect.hide()
	$WinLossRect/WinLabel.hide()
	$WinLossRect/LossLabel.hide()
	
	#check game_state--in other words, see if you have any more hearts left and if you don't and you just lost, game over!
	
func on_done_zoom_in():
#HERE IS WHERE WE NEED TO DEBUG!
#	from here, we await a couple seconds for the timer to run out and remove the colorrect
	mcg_timer.start(start_game_breather_time)
	await mcg_timer.timeout
	screen_cover.hide(); prompt_label.hide();prompt_label.text = prompt_label_initial_text
	#mcg_port_container.set_gui_input(true)
	if current_microgame._init_music_track:
		Globals.set_and_play_music(current_microgame._init_music_track)
	
	if !is_cur_mcg_boss:
		initialize_bomb_timer_visuals()
		mcg_timer.start(current_microgame._time_step)
	current_microgame._start()
	
func on_done_zoom_out():
	#couple things here... don't immediately pick the microgame, wait a little and also offload this to the maingame
	#second off: save the previous microgame for reference, even if only as a name
#	print(current_microgame)
#wait here in case we need to speed up!
<<<<<<< Updated upstream
	print(microgames_count)
	if microgames_count % boss_mcg_counter == 0 && microgames_count != 0:
		microgame_playmode = "queue"
		pick_microgame(true)
	else:
		microgame_playmode = "random_shuffle"
=======
	if microgames_count % mcg_count_to_gen_boss == 0:
		#pick boss_mcg()
		print("FUCK")
	else:
>>>>>>> Stashed changes
		pick_microgame()


func initialize_bomb_timer_visuals():
	bomb.position = bomb_init_pos
	bomb.texture = init_bomb_texture
	bomb_timer.show()


func on_increment_timer():
	if is_cur_mcg_boss:
		return
	if current_microgame == null:
		mcg_timer.stop()
		return
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

func update_num_hearts(update_type):#only add hearts every 10 or so, or maybe after every boss
	match update_type:
		"boss_failure":
			num_hearts -=1
		"failure":
			num_hearts -=1
		"boss_success":
			if num_hearts < max_hearts:
				num_hearts += 1
	if num_hearts == 0:
		pass
		#you lose!!!!e
	$PromptLabel/DEBUGHearts.text = str(num_hearts)
#	for normal microgames, we'd move onto the next one (or if you lose all lives, lose)

#	for boss microgames, we'd retry until success or until we're out of lives
