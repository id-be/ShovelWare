extends Node2D

@onready var games_handler = $MicroGamesHandler
@onready var camera_init_pos = Vector2(576, 324)

@onready var on_buttons = []
@onready var off_buttons = []

signal done_zoom_in
signal done_zoom_out

var tween

func _ready():
	$MicroGamesHandler.connect("zoom_into_microgame", Callable(self, "zoom_in"))
	$MicroGamesHandler.connect("zoom_out_of_microgame", Callable(self, "zoom_out"))

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func zoom_in():
	Globals.set_and_play_music(Globals.stings[1])
#	games_handler.current_microgame.set_process(false)
#	also need to pause the microgame...

	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "position", $MicroGamesHandler.position, 0.01)
	tween.tween_property($Camera2D, "zoom", Vector2(2.25, 2.25), 0.5)
	await tween.finished
#	games_handler.current_microgame.set_process(true)#this line is throwing errors
func zoom_out():
	#also need to pause the microgame....
	set_process_input(false)
	tween = get_tree().create_tween()
#	$Camera2D.position = camera_init_pos
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "position", Vector2(576, 324), 0.1)
	tween.tween_property($Camera2D, "zoom", Vector2(1, 1), 0.1)
	await tween.finished
	Globals.set_and_play_music(Globals.stings[4])
	set_process_input(true)
	
func toggle_pause():
		get_tree().paused = !get_tree().paused#this pauses the game
		Globals.toggle_sounds()
		if get_tree().paused:
			$PauseMenuMarginContainer.show()
			$PauseScreenTint.show()
			#pause the sound
		else:
			$PauseMenuMarginContainer.hide()
			$PauseScreenTint.hide()
			#resume the sound

func _on_resume_pressed():
	toggle_pause()
func _on_help_pressed():
	pass # Replace with function body.
func _on_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
