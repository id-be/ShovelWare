extends Node2D

@onready var tutorial_timer = $Timer

@onready var games_handler = $MicroGamesHandler
@onready var camera_init_pos = Vector2(576, 324)

@onready var on_buttons = []
@onready var off_buttons = []

@export var game_speed_multiplier = 1.0
@export var game_speed_increment = 0.1
@export var max_game_speed_up_increments = 6

@export var tutorial_mode = true#false will NOT show the button inputs.
@export var tutorial_time = 3
@export var end_time = 3

signal done_zoom_in
signal done_zoom_out

var tween

func _ready():
#	print(Globals.check_os())
	#$Camera2D.zoom = Vector2(1.35, 1.35)
	#$Camera2D.position = $MicroGamesHandler.position
	#zoom_in()
	
	$GameConsole.hide()
	games_handler.connect("screen_fx_toggled", Callable(self,"on_screen_fx_toggled"))
	games_handler.connect("zoom_into_microgame", Callable(self, "zoom_in"))
	games_handler.connect("zoom_out_of_microgame", Callable(self, "zoom_out"))
	games_handler.connect("get_input_flags", Callable(self, "get_input_flags"))

	games_handler.screen_fx_toggle()

	connect("done_zoom_in", Callable(games_handler, "on_done_zoom_in"))
	connect("done_zoom_out", Callable(games_handler, "on_done_zoom_out"))
	hide_hint_buttons()
func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	#if Input.is_action_just_pressed("plus"):
		#set_game_speed(game_speed_multiplier+0.1)
	#if Input.is_action_just_pressed("minus"):
		#set_game_speed(game_speed_multiplier-0.1)
func get_input_flags(input_flags):
	if !tutorial_mode:
		return
	var buttons_root_node = $GameConsole/ActionButtonHints
	var on_buttons_root_node = buttons_root_node.find_child("ButtonsOn")
	var off_buttons_root_node = buttons_root_node.find_child("ButtonsOff")
	var flag_button_names = {
		"button_0": "B"		, "button_1": "A",
		"microphone": "Mic"	, "mouse_touch": "Tap",
		"ui_down": "Down"	, "ui_left": "Left",
		"ui_right": "Right"	, "ui_up": "Up"}
	for flag in input_flags:
		match input_flags[flag]:
			true:
				on_buttons_root_node.find_child(flag_button_names[flag]).show()
			false:
#				off_buttons_root_node.find_child(flag_button_names[flag]).show()
				pass
func hide_hint_buttons():
	for hint_off in $GameConsole/ActionButtonHints/ButtonsOff.get_children():
		hint_off.hide()
	for hint_on in $GameConsole/ActionButtonHints/ButtonsOn.get_children():
		hint_on.hide()

func toggle_tutorial_mode():
	tutorial_mode = !tutorial_mode
	if tutorial_mode:
		tutorial_time = 3
	else:
		tutorial_time = 1

func on_screen_fx_toggled():
#	print("ROBBIE")
	if $Camera2D.zoom == Vector2(1,1):
		print("ROBBIE")
		return
	zoom_out(true)
	$GameConsole.show()
	games_handler.screen_fx_toggle()
	games_handler.pick_microgame()
	
func zoom_in(during_play = false):
	tutorial_timer.start(tutorial_time)
	await tutorial_timer.timeout
	hide_hint_buttons()
	if !during_play:
		Globals.set_and_play_music(Globals.stings[1])
#	also need to pause the microgame...

	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "position", $MicroGamesHandler.position, 0.01)
#	tween.tween_property($Camera2D, "zoom", Vector2(2.25, 2.25), 0.5)
	tween.tween_property($Camera2D, "zoom", Vector2(1.35, 1.35), 0.5)

	await tween.finished
	if !during_play:
		emit_signal("done_zoom_in")
#	games_handler.current_microgame.set_process(true)#this line is throwing errors
func zoom_out(during_play = false):
	#also need to pause the microgame....
	tween = get_tree().create_tween()
#	$Camera2D.position = camera_init_pos
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "position", Vector2(576, 324), 0.1)
	tween.tween_property($Camera2D, "zoom", Vector2(1, 1), 0.1)
	await tween.finished
	if !during_play:
		Globals.set_and_play_music(Globals.stings[4])
	#wait here for the music to finish plus some amount of time
	tutorial_timer.start(end_time)
	await tutorial_timer.timeout
#	await get_tree().create_timer(5).timeout
	if !during_play:
		emit_signal("done_zoom_out")
	
func toggle_pause():
		get_tree().paused = !get_tree().paused#this pauses the game
		Globals.toggle_sounds()
		if get_tree().paused:
			$PauseMenuMarginContainer.show()
			$PauseScreenTint.show()
			#really shouldn't need this line.... not sure what's going on
			Globals.sfx_player.set_stream_paused(true)
			Globals.music_player.set_stream_paused(true)
			#pause the sound
		else:
			$PauseMenuMarginContainer.hide()
			$PauseScreenTint.hide()
			Globals.sfx_player.set_stream_paused(false)
			Globals.music_player.set_stream_paused(false)
			#resume the sound

func set_game_speed(speed):
	game_speed_multiplier = speed
	AudioServer.playback_speed_scale = game_speed_multiplier
	Engine.time_scale = game_speed_multiplier

func _on_resume_pressed():
	toggle_pause()
func _on_help_pressed():
	pass # Replace with function body.
func _on_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
