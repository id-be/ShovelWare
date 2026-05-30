extends Node2D;

var intro_flag = 0;

@onready var tutorial_timer = $Timer;

@onready var games_handler = $MicroGamesHandler;
@onready var camera_init_pos = Vector2(576, 324);

@onready var on_buttons = [];
@onready var off_buttons = [];

@export var game_speed_multiplier = 1.0;
@export var game_speed_increment = 0.1;
@export var max_game_speed_up_increments = 6;

var can_pause: bool = false;

@export var skip_intro = true;

@export var tutorial_mode = true;#false will NOT show the button inputs.
@export var tutorial_time = 3;
@export var end_time = 3;

var zoom_in_multiplier = 1.35;
#var zoom_out_multiplier = 1.0;
var zoom_out_multiplier = 1.0;

signal done_zoom_in;
signal done_zoom_out;

var tween;

#things to change: we need the pause menu to go back to the main menu, the help button to do something, the quit button to quit or possibly be moved to the main menu..

func _ready() -> void:
	if Globals.check_os() == "mobile":
		zoom_out_multiplier = 0.95;
		zoom_in_multiplier = zoom_out_multiplier;
#	-(Globals.check_os())
	#$Camera2D.zoom = Vector2(1.35, 1.35)
	#$Camera2D.position = $MicroGamesHandler.position
	#zoom_in()
	

	games_handler.connect("screen_fx_toggled", Callable(self,"on_screen_fx_toggled"));
	games_handler.connect("zoom_into_microgame", Callable(self, "zoom_in"));
	games_handler.connect("zoom_out_of_microgame", Callable(self, "zoom_out"));
	games_handler.connect("get_input_flags", Callable(self, "get_input_flags"));
	connect("done_zoom_in", Callable(games_handler, "on_done_zoom_in"));
	connect("done_zoom_out", Callable(games_handler, "on_done_zoom_out"));
	hide_hint_buttons();
	await play_intro_cinematic();

func play_intro_cinematic() -> void:
	if skip_intro:
		zoom_out(true);
		$DeanBoy.show();
		$MicroGamesHandler.pick_microgame();
		can_pause = true;
		return;
	$DeanBoy.hide();
	
	await games_handler.screen_fx_toggle();
	$AnimSprite.scale = Vector2(7,7);
	Globals.set_and_play_sfx(load("res://Scenes/MainGame/Assets/Sound/Ooo.wav"));
	await play_cinematic("Deanboy");
	tutorial_timer.start(0.2);
	await tutorial_timer.timeout;
	await games_handler.screen_fx_toggle();
	

	await games_handler.screen_fx_toggle();
	#here is where we play the shovelware cinematic
	#add a tween in
	var beach_sound = load("res://Scenes/MainGame/Assets/Sound/Beach.wav");
	var my_cur_sound_len = beach_sound.get_length();
	$AnimSprite.scale = Vector2(3,3);
	$AnimSprite.modulate = Color(0.0,0.0,0.0,0.0);
	
	tween = get_tree().create_tween();
	tween.tween_property($AnimSprite, "modulate", Color(1.0,1.0,1.0,1.0), 1.0);
	
	play_cinematic("Shovel");
	Globals.set_and_play_sfx(beach_sound);
	
	var go_away_time = 0.5;
	
	tutorial_timer.wait_time = my_cur_sound_len - go_away_time;
	tutorial_timer.start();
	#add a tween out
	#hide the cinematics handler
	await tutorial_timer.timeout;
	tween = get_tree().create_tween();
	tween.tween_property($AnimSprite, "modulate", Color(0.0, 0.0, 0.0, 1.0), go_away_time);
	await tween.finished;
	
	tutorial_timer.wait_time = go_away_time;
	tutorial_timer.start();
	await tutorial_timer.timeout;
	
	zoom_out(true);
	$DeanBoy.show();
	$MicroGamesHandler.pick_microgame();
	can_pause = true;
	
	await games_handler.screen_fx_toggle();

func play_cinematic(cinematic) -> void:#a different idea here: we need to create a cinematic "script" object
	#
	$AnimSprite.show();
	$AnimSprite.play(cinematic);
	await $AnimSprite.animation_finished;
	$AnimSprite.hide();

func _input(_event) -> void:
	if Input.is_action_just_pressed("start_button"):
		if can_pause:
			toggle_pause();
	#if Input.is_action_just_pressed("plus"):
		#set_game_speed(game_speed_multiplier+0.1)
	#if Input.is_action_just_pressed("minus"):
		#set_game_speed(game_speed_multiplier-0.1)
func get_input_flags(input_flags) -> void:
	if !tutorial_mode:
		return;
	var buttons_root_node = $DeanBoy/ActionButtonHints;
	var on_buttons_root_node = buttons_root_node.find_child("ButtonsOn");
	var off_buttons_root_node = buttons_root_node.find_child("ButtonsOff");
	var flag_button_names = {
		"button_0": "B"		, "button_1": "A",
		"microphone": "Mic"	, "mouse_touch": "Tap",
		"ui_down": "Down"	, "ui_left": "Left",
		"ui_right": "Right"	, "ui_up": "Up"};
	for flag in input_flags:
		match input_flags[flag]:
			true:
				if flag=="mouse_touch":
					$TouchButtons/Hand.show()
				on_buttons_root_node.find_child(flag_button_names[flag]).show();
			false:
#				off_buttons_root_node.find_child(flag_button_names[flag]).show()
				pass
func hide_hint_buttons() -> void:
	for hint_off in $DeanBoy/ActionButtonHints/ButtonsOff.get_children():
		hint_off.hide();
	for hint_on in $DeanBoy/ActionButtonHints/ButtonsOn.get_children():
		hint_on.hide();
	$TouchButtons/Hand.hide()

func toggle_tutorial_mode() -> void:
	tutorial_mode = !tutorial_mode;
	if tutorial_mode:
		tutorial_time = 3;
	else:
		tutorial_time = 1;

func on_screen_fx_toggled() -> void:
	games_handler.screen_fx_toggle();
##	

func zoom_in(during_play = false) -> void:
	tutorial_timer.start(tutorial_time);
	await tutorial_timer.timeout;
	hide_hint_buttons();
	if !during_play:
		Globals.set_and_play_music(Globals.stings[1]);
#	also need to pause the microgame...

	tween = get_tree().create_tween();
	tween.set_parallel(true);
	tween.tween_property($Camera2D, "position", $MicroGamesHandler.position, 0.01);
#	tween.tween_property($Camera2D, "zoom", Vector2(2.25, 2.25), 0.5)
	tween.tween_property($Camera2D, "zoom", Vector2(zoom_in_multiplier, zoom_in_multiplier), 0.5);

	await tween.finished;
	if !during_play:
		emit_signal("done_zoom_in");
#	games_handler.current_microgame.set_process(true)#this line is throwing errors
func zoom_out(during_play = false) -> void:
	#also need to pause the microgame....
	tween = get_tree().create_tween();
#	$Camera2D.position = camera_init_pos
	tween.set_parallel(true);
	tween.tween_property($Camera2D, "position", Vector2(576, 324), 0.1);
	tween.tween_property($Camera2D, "zoom", Vector2(zoom_out_multiplier, zoom_out_multiplier), 0.1);
	await tween.finished;
	if !during_play:
		Globals.set_and_play_music(Globals.stings[4]);
	#wait here for the music to finish plus some amount of time
	tutorial_timer.start(end_time);
	await tutorial_timer.timeout;
#	await get_tree().create_timer(5).timeout
	if !during_play:
		emit_signal("done_zoom_out");

func toggle_pause() -> void:
		get_tree().paused = !get_tree().paused;#this pauses the game
		Globals.toggle_sounds();
		if get_tree().paused:
			$PauseMenuMarginContainer.show();
			$PauseScreenTint.show();
			#really shouldn't need this line.... not sure what's going on
			Globals.sfx_player.set_stream_paused(true);
			Globals.music_player.set_stream_paused(true);
			#pause the sound
		else:
			$PauseMenuMarginContainer.hide();
			$PauseScreenTint.hide();
			Globals.sfx_player.set_stream_paused(false);
			Globals.music_player.set_stream_paused(false);
			#resume the sound

func set_game_speed(speed) -> void:
	game_speed_multiplier = speed;
	AudioServer.playback_speed_scale = game_speed_multiplier;
	Engine.time_scale = game_speed_multiplier;

func _on_resume_pressed() -> void:
	toggle_pause();
func _on_help_pressed() -> void:
	pass # Replace with function body.
func _on_to_menu_pressed() -> void:
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn");
