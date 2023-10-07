extends Control


@export var quit_pop_up = Node
@export var menu_options_vbox = Node

@onready var main_game = load("res://Scenes/MainGame/MainGame.tscn")

var menu_state#make a state machine for the menu
enum {START, PLAY, HELP, OPTIONS, GALLERY, QUIT}


func _ready():
	_set_quit_pop_up_settings()
	_set_menu_state(START)


func _input(event):
	if menu_state == START:
		if Input.is_action_just_pressed("ui_cancel"):
			quit_pop_up.popup()


func _set_menu_state(STATE):
	menu_state = STATE


#main_menu
#	play --> pick play mode
#		mode --> go to game
#	how to play --> simple instructions
#	options
#		volume mixer
#		input binding --> change which button does what
#	credits --> a gallery to look at the microgames and see who contributed what to them (maybe a short demo to play if you click on them)
#	quit --> quit game

func _to_start_menu():
	#hide everything that 
	pass


func _on_play_pressed():
	get_tree().change_scene_to_packed(main_game)


func _on_help_pressed():
	pass # Replace with function body.


func _on_options_pressed():
	pass # Replace with function body.


func _on_gallery_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	quit_pop_up.popup()


func _set_quit_pop_up_settings():
	quit_pop_up.set_exclusive(true)#this is key. this kills all input that doesn't go directly to the popup
	quit_pop_up.borderless = false
	quit_pop_up.add_item("Yes")
	quit_pop_up.add_item("No")


func _on_quit_popup_menu_about_to_popup():
	menu_options_vbox.hide()
	_set_menu_state(QUIT)


func _on_quit_popup_menu_index_pressed(index):
	if index == 0:
		get_tree().quit()


func _on_quit_popup_menu_popup_hide():
	menu_options_vbox.show()
	_set_menu_state(START)


