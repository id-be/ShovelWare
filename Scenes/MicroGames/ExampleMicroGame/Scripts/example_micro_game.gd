extends microgame

@export var move_speed = 5
@export var base_speed_multiplier = 40

func _set_difficulty(dif):
	difficulty = dif
	var temp_col
	match dif:
		"easy":
			move_speed = 3
			temp_col = Color(0,0,1)
		"medium":
			move_speed = 4
			temp_col = Color(0,1,0)
		"hard":
			move_speed = 6
			temp_col = Color(1,0,0)
	$MoveButton.modulate = temp_col
func _set_initial_values():
	var screen_size = get_viewport_rect().size
	var start_num_1 = randf_range(-1,1)
	var start_num_2 = randf_range(-1,1)

	$MoveButton.position = screen_size/2

	$MoveButton.velocity = move_speed * base_speed_multiplier * Vector2(start_num_1,start_num_2).normalized()

func _physics_process(delta):
	move_button_around(delta)

func move_button_around(delta):
	var collision_info = $MoveButton.move_and_collide($MoveButton.velocity * delta)
	if collision_info:#in other words, if collision_info!=null
		var rand_angle = randf_range(-PI/4,PI/4)
		var bounce_vel = $MoveButton.velocity.bounce(collision_info.get_normal())
		$MoveButton.velocity = bounce_vel.rotated(rand_angle)

func _on_button_pressed():
	set_process(false)
	end_state = "success"
