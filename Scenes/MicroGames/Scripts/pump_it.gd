extends microgame

@export var max_pump_val = 3
var current_pump_val = 0
var is_up = false	
	
func _set_difficulty(dif):
	match dif:
		"easy":
			max_pump_val = 5
		"medium":
			max_pump_val = 7
		"hard":
			max_pump_val = 10
func _set_initial_values():
	var screen_size = get_viewport_rect().size
	var start_num_1 = randf_range(-1,1)
	var start_num_2 = randf_range(-1,1)
	#$TestText.text = str(current_pump_val)

	#$MoveButton.position = screen_size/2
	#$MoveButton.velocity = move_speed * base_speed_multiplier * Vector2(start_num_1,start_num_2).normalized()

func _process(_delta):
	$PumpValue.text = str(current_pump_val)
	if is_up: 
		$DirectionText.text = "Down!"
	else:
		$DirectionText.text = "Up!"
#Maybe look at this logic again lol

func check_win():
	if current_pump_val > max_pump_val:
		end_state = "success"

func press_down():
	is_up = false
	current_pump_val += 1
	$BalloonOrigin.scale *= 1.05
	$PumpTop.position.y = 96
	
func press_up():
	is_up = true
	current_pump_val += 1
	$BalloonOrigin.scale *= 1.05
	$PumpTop.position.y = 80
	
	

func _input(event):
	if Input.is_action_just_pressed("ui_up") && !event.is_echo():
		if(is_up == false):
			press_up()
			check_win()
	if Input.is_action_just_pressed("ui_down") && !event.is_echo():
		if(is_up == true):
			press_down()
			check_win()
		

func _on_button_pressed():
	set_process(false)
	end_state = "success"

func _on_area_2d_mouse_entered():
	print("STUFF")


func _on_area_2d_mouse_shape_entered(shape_idx):
	print("STUFF2")
	pass # Replace with function body.
