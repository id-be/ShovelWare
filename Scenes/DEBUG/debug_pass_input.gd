extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	$SubViewportContainer/SubViewport.push_unhandled_input(event, false)
	$SubViewportContainer/SubViewport.push_input(event, false)

	#if Input.is_action_just_pressed("button_0"):
		#$SubViewportContainer/SubViewport.get_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
