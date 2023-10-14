extends Node2D

@onready var games_handler = $MicroGamesHandler

#func _notification(what):
#	print(what)


func _ready():
	$MicroGamesHandler.connect("zoom_into_microgame", Callable(self, "start_zoom_in"))


#for some reason the pause menu unpauses the game when the microgame is paused(???)


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func start_zoom_in():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Camera2D, "position", $MicroGamesHandler.position, 0.5)
	tween.tween_property($Camera2D, "zoom", Vector2(1.775, 1.775), 0.5)
#	await tween.finished


func toggle_pause():
		get_tree().paused = !get_tree().paused#this pauses the game
		if get_tree().paused:
			$PauseMenuMarginContainer.show()
			$PauseScreenTint.show()
		else:
			$PauseMenuMarginContainer.hide()
			$PauseScreenTint.hide()


func _process(_delta):
	pass


func _on_resume_pressed():
	toggle_pause()


func _on_help_pressed():
	pass # Replace with function body.


func _on_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
	pass # Replace with function body.
