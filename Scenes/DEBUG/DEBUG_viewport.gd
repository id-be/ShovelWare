extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport/ExampleMicroGame._start()
	$SubViewportContainer.mouse_filter = SubViewportContainer.MOUSE_FILTER_PASS

func _input(event):
	if Input.is_action_just_pressed("button_0"):
		get_tree().get_root().warp_mouse($SubViewportContainer/SubViewport/ExampleMicroGame/Sprite2D/Area2D.position)
		pass

#func _input(event):
#	$SubViewportContainer.input(event)


#func _input(event):
#	$SubViewportContainer/SubViewport.push_input(event, true)

#func _unhandled_input(event):
#	$SubViewportContainer/SubViewport.push_input(event, true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
