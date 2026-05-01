#control node: "neighbor" category, eg NodePath focus_neighbor_bottom = NodePath("")

#refactor this so that we can properly loop on a grid container.

#rather than setting index from the input, we should probably set index
#from the (n+1)%num_columns calculation of 

#things that need to work: you start at menu position 0. you restart there when you
#make the menu visible

extends Control;

@export var cursor_offset := Vector2(20,9);
@export var texture_offset := Vector2(0,0);
@export var label_offset := Vector2(0,0);

@export_enum("texture", "label") var cursor_type = "label";
@export_enum("mouse", "keys", "both") var nav_type = "both";

@export var menu_parent_path : NodePath;
@onready var menu_parent := get_node(menu_parent_path);

var cursor_index : int = 0;
var prev_cursor_index := cursor_index;
var current_menu_item : Node;#make this saved as opposed to getting it when button_1 is pressed
# Called when the node enters the scene tree for the first time.
var menu_diagonal;# this will be the vector across the element from top left to bottom right.

func _ready() -> void:
	menu_parent.connect("visibility_changed", Callable(self,"on_menu_parent_visibility_changed"));
	for child in menu_parent.get_children():
			if child.has_method("_cursor_select") or child.has_method("is_pressed"):
				var enter_callable = Callable(self, "on_mouse_entered");
				var enter_bound_callable = enter_callable.bind(child);
				var exit_callable = Callable(self, "on_mouse_exited");
				var exit_bound_callable = exit_callable.bind(child);
				child.connect("mouse_entered", enter_bound_callable);
				child.connect("mouse_exited", exit_bound_callable);
	set_cursor_from_index(0);

#what we need to do: on mouse movement, we disable the keys. on key press, we disable the mouse.

func _process(_delta):
	var input := Vector2.ZERO;
	if Input.is_action_just_pressed("ui_up"):
		input.y -=1;
		set_cursor_from_menu_parent(input);
	if Input.is_action_just_pressed("ui_down"):
		input.y +=1;
		set_cursor_from_menu_parent(input);
	if Input.is_action_just_pressed("ui_left"):
		input.x -=1;
		set_cursor_from_menu_parent(input);
	if Input.is_action_just_pressed("ui_right"):
		input.x +=1;
		set_cursor_from_menu_parent(input);
# we really don't need this happening every single frame. set it once at the outset then every time you move the index

	if Input.is_action_just_pressed("button_1"):
		if current_menu_item != null:
			if current_menu_item.has_method("_cursor_select"):
				current_menu_item._cursor_select();
			elif current_menu_item.has_method("is_pressed"):
				current_menu_item.emit_signal("pressed");

func set_cursor_from_menu_parent(input):
	if menu_parent is VBoxContainer:
		set_cursor_from_index(cursor_index + input.y);
	elif menu_parent is HBoxContainer:
		set_cursor_from_index(cursor_index + input.x);
	elif menu_parent is GridContainer:
		set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns);
	prev_cursor_index = cursor_index;

#i think this is where you start selecting the item
func get_menu_item_at_index(index : int) -> Control:
	if menu_parent == null:
		return null;
	if index >= menu_parent.get_child_count() or index <0:
		if index >= menu_parent.get_child_count():
			set_cursor_from_index(0);
		elif index <0:
			set_cursor_from_index(menu_parent.get_child_count()-1);
		return null;

	return menu_parent.get_child(index) as Control;

# something along these lines? rework obviously
	#print(index)
#
	#if menu_parent == null:
		#return null
	#if index >= menu_parent.get_child_count() or index <0:
		#if index >= menu_parent.get_child_count():
			#index = 0
		#elif index <= 0:
			#index = menu_parent.get_child_count()-1
	#return menu_parent.get_child(index) as Control

func set_cursor_from_index(index : int) -> void:
	var menu_item := get_menu_item_at_index(index);
	
	

	if menu_item == null:
		#this is where we check if the next slot is null (we have reached the edge of our grid!)
#		print("NO NEXT STEP!")
		return;
	var my_position = menu_item.global_position;
	var my_size = menu_item.size;
	
	global_position = Vector2(my_position.x, my_position.y + my_size.y/2.0) - cursor_offset;
	current_menu_item = menu_item;
	if current_menu_item.has_method("grab_focus"):
		current_menu_item.grab_focus();
	cursor_index = index;

func toggle_self(state):
	set_process(state);

func on_menu_parent_visibility_changed():
	await get_tree().process_frame;
	await get_tree().process_frame;
	if menu_parent.is_visible_in_tree():

		set_cursor_from_index(0);

func on_mouse_entered(button):
	button.grab_focus();
	
func on_mouse_exited(button):
	button.release_focus();

func on_menu_parent_item_hover():
	pass;
