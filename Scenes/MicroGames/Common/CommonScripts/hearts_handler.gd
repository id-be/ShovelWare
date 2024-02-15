extends Node2D

@export_range(1,10) var heart_count = 3
@export_range(1,20) var heart_distance : float = 5
@export_enum("horizontal", "vertical", "grid") var layout_type : String = "horizontal"
@export_enum("horizontal", "vertical") var grid_fill_type : String = "horizontal"
@export_range(1,20) var grid_fill_length = 8

@export_enum("fill", "countdown") var hearts_mode = "fill"

@export var should_synch_hearts : bool = true

@export var heart : PackedScene

var heart_size
var num_active_hearts = 0

var is_done = false

# Called when the node enters the scene tree for the first time.

signal last_heart


func set_num_hearts(hc = heart_count):
	remove_all_hearts()
	add_hearts(hc)

func add_hearts(heart_count = 1):
	for num in heart_count:
		var instance = heart.instantiate()
		var prev_heart_pos
		if get_children().is_empty() && heart_size == null:
	#	print(instance.name)
			prev_heart_pos = Vector2(0,0)
			heart_size = instance.get_anim_frame_size()
		elif !get_children().is_empty():
			prev_heart_pos = get_children()[-1].position
			if get_children()[-1].is_queued_for_deletion():
				prev_heart_pos = Vector2(0,0)
			set_heart_offset(instance, prev_heart_pos)
		add_child(instance)
		instance.name = "UIHeart1"
		if hearts_mode == "fill":
			instance.set_active(false)
			num_active_hearts = 0
		elif hearts_mode == "countdown":
			instance.set_active(true)
			num_active_hearts = get_children().size()
		instance.play_anim()
		
	if should_synch_hearts:
		synchronize_hearts()
	heart_count = get_children().size()
	#if prev_heart_pos != null:
		#print(prev_heart_pos)

func get_active_heart_count():
	num_active_hearts = 0
	for child in get_children():
		if child.is_active:
			num_active_hearts += 1
	return num_active_hearts
	
func synchronize_hearts():
	for child in get_children():
		child.stop_anim()
		child.play_anim()

func set_heart_offset(new_heart_instance = null, prev_pos = Vector2(0,0)):
	match layout_type:
		"horizontal":
			new_heart_instance.position.x = prev_pos.x + heart_size.x + heart_distance
		"vertical":
			new_heart_instance.position.y = prev_pos.y + heart_size.y + heart_distance
		"grid":
			pass

func remove_hearts(heart_count = 1):
	if heart_count > get_children().size():
		heart_count = get_children().size()
	for num in heart_count:
		get_children()[-(num+1)].free()
	heart_count = get_children().size()
	get_active_heart_count()
		
func remove_all_hearts():
	for child in get_children():
		child.free()
	heart_count = get_children().size()
	get_active_heart_count()

func change_hearts_state():
	match hearts_mode:
		"fill":
			for child in get_children():
				if !child.is_active:
					child.set_active(true)
					synchronize_hearts()
					if get_active_heart_count() == get_children().size():
						emit_signal("last_heart")
						is_done = true
					return
		"countdown":
			var child_array = get_children()
			var child_array_size = child_array.size()
			for child in child_array_size:
				var cur_child = child_array[-child-1]
				if cur_child.is_active:
					cur_child.set_active(false)
					synchronize_hearts()
					if get_active_heart_count() == 0:
						emit_signal("last_heart")
						is_done = true
					return
	get_active_heart_count()
	
func get_heart_count():
	return heart_count

#func _input(event):
	#if Input.is_action_just_pressed("ui_accept"):
		#remove_all_hearts()
	#if Input.is_action_just_pressed("DEBUG_MOUSE"):
		#remove_hearts()
	#if Input.is_action_just_pressed("button_0"):
		#set_num_hearts(1)
##		add_hearts()
