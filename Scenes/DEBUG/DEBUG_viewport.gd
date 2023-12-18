extends SubViewportContainer

func _ready():
	set_process_input(true)
	set_process_unhandled_input(true)

func _gui_input(event):
	print(event)
#func _input(event):
	## fix by ArdaE https://github.com/godotengine/godot/issues/17326#issuecomment-431186323
	#for child in get_children():
		#if event is InputEventMouse:
			#var mouseEvent = event.duplicate()
			#mouseEvent.position = get_global_transform_with_canvas().affine_inverse() * event.position
			#child._unhandled_input(mouseEvent)
		#else:
			#child._unhandled_input(event)




## Called when the node enters the scene tree for the first time.
#func _ready():
	#set_process_input(true)
	#set_process_unhandled_input(true)
##	$SubViewportContainer/SubViewport/ExampleMicroGame._start()
##	$SubViewportContainer.mouse_filter = SubViewportContainer.MOUSE_FILTER_PASS
##
##func _input(event):
##	if Input.is_action_just_pressed("button_0"):
##		get_tree().get_root().warp_mouse($SubViewportContainer/SubViewport/ExampleMicroGame/Sprite2D/Area2D.position)
##		pass
#
##func _unhandled_input(event):
	##for child in get_child(0).get_children():
		##if event is InputEventMouse:
			##var mouseEvent = event.duplicate()
			##mouseEvent.position = get_global_transform_with_canvas().affine_inverse() * event.position
			##child._unhandled_input(mouseEvent)
		##else:
			##child._unhandled_input(event)
#
#func _gui_input(event):
##	print(event)
	#$SubViewport.push_input(event, true)
##	print("GUIGUIGUI!!!")
#
##func _input(event):
##	$SubViewportContainer.input(event)
#
#
##func _input(event):
##	$SubViewportContainer/SubViewport.push_input(event, true)
#
##func _unhandled_input(event):
##	$SubViewportContainer/SubViewport.push_input(event, true)
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
