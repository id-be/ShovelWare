extends Node

@onready var games_handler = $MicroGamesHandler
# Called when the node enters the scene tree for the first time.
func _ready():
#	print(Globals.check_os())
	#$Camera2D.zoom = Vector2(1.35, 1.35)
	#$Camera2D.position = $MicroGamesHandler.position
	zoom_in()
	

	games_handler.connect("screen_fx_toggled", Callable(self,"on_screen_fx_toggled"))
	games_handler.connect("zoom_into_microgame", Callable(self, "zoom_in"))
	games_handler.connect("zoom_out_of_microgame", Callable(self, "zoom_out"))
	games_handler.connect("get_input_flags", Callable(self, "get_input_flags"))
	connect("done_zoom_in", Callable(games_handler, "on_done_zoom_in"))
	connect("done_zoom_out", Callable(games_handler, "on_done_zoom_out"))


func zoom_in(during_play = false):
	pass
	if !during_play:
		Globals.set_and_play_music(Globals.stings[1])
#	also need to pause the microgame...
		emit_signal("done_zoom_in")
#	games_handler.current_microgame.set_process(true)#this line is throwing errors
func zoom_out(during_play = false):
	#also need to pause the microgame....
	pass
	if !during_play:
		Globals.set_and_play_music(Globals.stings[4])
	#wait here for the music to finish plus some amount of time
	if !during_play:
		emit_signal("done_zoom_out")
