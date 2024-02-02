#control node: "neighbor" category, eg NodePath focus_neighbor_bottom = NodePath("")





extends Control

@export var cursor_offset = Vector2(20,9)
@export var texture_offset = Vector2(0,0)
@export var label_offset = Vector2(0,0)


@export var menu_parent_path : NodePath
@onready var menu_parent := get_node(menu_parent_path)

var cursor_index : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var input := Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"):
		input.y -=1
	if Input.is_action_just_pressed("ui_down"):
		input.y +=1
	if Input.is_action_just_pressed("ui_left"):
		input.x -=1
	if Input.is_action_just_pressed("ui_right"):
		input.x +=1
		
	if menu_parent is VBoxContainer:
			set_cursor_from_index(cursor_index + input.y)
	elif menu_parent is HBoxContainer:
			set_cursor_from_index(cursor_index + input.x)
	elif menu_parent is GridContainer:
			set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns)
	
	if Input.is_action_just_pressed("button_1"):
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("_cursor_select"):
				current_menu_item._cursor_select()
	
func get_menu_item_at_index(index : int) -> Control:
	if menu_parent == null:
		return null
	if index >= menu_parent.get_child_count() or index <0:
		return null
	return menu_parent.get_child(index) as Control
# Called every frame. 'delta' is the elapsed time since the previous frame.

func set_cursor_from_index(index : int) -> void:
	var menu_item := get_menu_item_at_index(index)
	
	if menu_item == null:
		#this is where we check if the next slot is null (we have reached the edge of our grid!)
#		print("NO NEXT STEP!")
		return
	
	var position = menu_item.global_position
	var size = menu_item.size
	
	#global_position = Vector2(position.x, position.y + size.y/2.0) - (size/2.0) - cursor_offset
	global_position = Vector2(position.x, position.y + size.y/2.0) - cursor_offset
	
	cursor_index = index
