extends Control

signal splash_done
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("splash_done", Callable(self, "on_end_splash"))
	emit_signal("splash_done")
	pass # Replace with function body.
#	get splash anim ready

func on_end_splash():
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
