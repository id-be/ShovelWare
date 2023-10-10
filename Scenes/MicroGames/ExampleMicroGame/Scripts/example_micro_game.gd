extends Node2D

@export var move_speed = 5
@export var base_speed_multiplier = 40

var difficulty = "easy"

signal start_game
signal end_game


func _init(dif = difficulty):
	difficulty = dif
func _ready():
	match difficulty:
		"easy":
			move_speed = 5
		"medium":
			move_speed = 8
		"hard":
			move_speed = 12
	var screen_size = get_viewport_rect().size
	var start_num_1 = randf_range(-1,1)
	var start_num_2 = randf_range(-1,1)

	$MoveButton.position = screen_size/2
	$MoveButton.velocity = move_speed * base_speed_multiplier * Vector2(start_num_1,start_num_2).normalized()
	emit_signal("start_game")


func _physics_process(_delta):
	move_button_around()
#Maybe look at this logic again lol
func move_button_around():
	var vel_before_collision = $MoveButton.velocity
#	var normal_vel_before_collision = vel_before_collision.normalized()#may not need
	$MoveButton.move_and_slide()
#	print(vel_before_collision)
	if $MoveButton.get_slide_collision_count() > 0:
		if $MoveButton.get_slide_collision(0) != null:
#			print(rad_to_deg($MoveButton.get_slide_collision(0).get_remainder().x))
			var phi = $MoveButton.get_last_slide_collision().get_normal().angle_to(vel_before_collision)

#			print($MoveButton.get_last_slide_collision().get_angle())
#			print($MoveButton.get_velocity())
#			if is_equal_approx(abs(phi), PI):
#				#special case we need to consider
#				$MoveButton.velocity = vel_before_collision.rotated(PI)
			if phi <= 0:
				var rand_angle = randf_range(PI/2, phi)
				$MoveButton.velocity = vel_before_collision.rotated(rand_angle)
			elif phi > 0:
				var rand_angle = -randf_range(PI/2, phi)
				$MoveButton.velocity = vel_before_collision.rotated(rand_angle)
func _on_button_pressed():
	emit_signal("end_game", "success")
