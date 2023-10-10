extends Node2D

@onready var games_handler = $MicroGamesHandler

func _ready():
	pass


func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
		get_tree().paused = !get_tree().paused#this pauses the game
		if get_tree().paused:
			$PauseMenuMarginContainer.show()
			$PauseScreenTint.show()
		else:
			$PauseMenuMarginContainer.hide()
			$PauseScreenTint.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
