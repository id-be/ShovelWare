extends Node;

@onready var music_player = $Music;
@onready var sfx_player = $SFX;

@onready var stings = [
	load("res://Scenes/MainGame/Assets/Sound/Ready.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Ready2.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Ominous.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/ULose.ogg"),
	load("res://Scenes/MainGame/Assets/Sound/Win2.ogg"),
	load("res://Scenes/MicroGamesHandler/Assets/Audio/Static.wav"),
	load("res://Scenes/MicroGamesHandler/Assets/Audio/TVTurnOff.wav")
];

var cur_music_track_pos;
var music_track_queue = [];

var cur_sfx_track_pos;
var sfx_track_queue = [];


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print(AudioServer.bus_count)
#	AudioServer.playback_speed_scale
#	print(AudioServer.get_bus_name(3))
#	print(AudioServer.get_bus_channels(3))
#	AudioServer.get_bus_channels()

#	pick a random track for the menu
	pass # Replace with function body.

func check_os() -> String:
	var os_name
	
	#change this to OS.has_feature(feature) so you have more control
	if OS.has_feature("pc"):
		os_name="pc"
	elif OS.has_feature("mobile"):
		os_name="mobile"
	elif OS.has_feature("web"):
		if OS.has_feature("web_android") or OS.has_feature("web_ios"):
			os_name="mobile"
		else:
			os_name="pc"
	return os_name;

#func _create_microgames_input_array():
	#pass;

func _input(_event):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("DEBUG_Quit"):	
			get_tree().quit();
	else:
		self.set_process_input(false);

func _queue_music_track() -> void:
	pass;
func set_music_track(track) -> void:
	music_player.set_stream(track);
func play_music() -> void:
	music_player.play();
func stop_music() -> void:
	music_player.stop();
func set_and_play_music(track) -> void:
	set_music_track(track);
	play_music();
func _on_music_finished() -> void:
	music_player.stream = null;
func toggle_music() -> void:
	music_player.stream_paused = !music_player.stream_paused;

func _queue_sfx_track() -> void:
	pass;
func set_sfx_track(track) -> void:
	sfx_player.set_stream(track);
func play_sfx() -> void:
	sfx_player.play();
func stop_sfx() -> void:
	sfx_player.stop();
func set_and_play_sfx(track) -> void:
	set_sfx_track(track);
	play_sfx();
func _on_sfx_finished() -> void:
	sfx_player.stream = null;
func toggle_sfx() -> void:
	sfx_player.stream_paused = !sfx_player.stream_paused;

func toggle_sounds() -> void:
	toggle_music();
	toggle_sfx();
#basically, if they're playing you want to pause them and save the current
#playback position then if they're not playing and we hit toggle sound, we 
#want to resume playing from the spot we stopped at.
func kill_sounds() -> void:
	stop_music();
	stop_sfx();
