extends Control

@export_group("Menu Options")
@export var menu_start_box = Node
@export var menu_play_box = Node
@export var menu_help_box = Node
@export var menu_options_box = Node
@export var menu_gallery_box = Node
@export var quit_pop_up = Node

@onready var main_game = load("res://Scenes/MainGame/MainGame.tscn")

@onready var set_of_menu_items = [menu_start_box, menu_play_box, menu_help_box, 
menu_options_box, menu_gallery_box, quit_pop_up]


func _ready():
	_set_quit_pop_up_settings()
	to_start_menu()


func _input(_event):
	if menu_start_box.is_visible():
		if Input.is_action_just_pressed("ui_cancel"):
			quit_pop_up.popup()
	elif menu_play_box.is_visible():
		if Input.is_action_just_pressed("ui_cancel"):
			to_start_menu()


func hide_all_but_selected(MENU_ITEM):
	for menu_item in set_of_menu_items:
		if menu_item == MENU_ITEM:
			menu_item.show()
		else:
			menu_item.hide()


func to_start_menu():
	hide_all_but_selected(menu_start_box)


func _on_play_pressed():
	hide_all_but_selected(menu_play_box)
func _on_mode_1_pressed():
	get_tree().change_scene_to_packed(main_game)
func _on_mode_2_pressed():
	pass # Replace with function body.
func _on_mode_3_pressed():
	pass # Replace with function body.
func _on_play_back_pressed():
	to_start_menu()


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
	quit_pop_up.add_item("Yes")
	quit_pop_up.add_item("No")


func _on_quit_popup_menu_about_to_popup():
	hide_all_but_selected(null)


func _on_quit_popup_menu_index_pressed(index):
	if index == 0:
		get_tree().quit()


func _on_quit_popup_menu_popup_hide():
	to_start_menu()



