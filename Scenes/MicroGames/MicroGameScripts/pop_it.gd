extends microgame

var can_click

var num_balloons = 3
@export_enum("hot_air", "circus", "birthday") var balloons_type: String
#right now: need to hook up logic so that on popping a) play a pop sound (also
#need to find a pop sound) b) we check how many children balloonhandler has 
#and when that number reaches 0 c) we set end_state to success.

#next steps: clean up assets for the balloons, make it so that hflip for background
#is randomized, make assets for medium and hard, add falling and screaming 
#people to hot air ballons, get the balloon strings set up

#export(String, "hot_air", "circus", "birthday") var game_mode

#refactor this shit... it looks like the balloons start moving
#around even without having to wait for start.

#	16 wide. 12 is the min, 236-8=228 is the max. so we need to
#	make this balloon placed such that its position is between
#	extents+12 and 228-extents

#to add to this: multiple backgrounds, functionality for multiple difficulty levels (kid with
#balloons, clown with balloons, balloons with strings etc)

class balloon extends AnimatedSprite2D:
	var can_be_clicked = false
	var pop_time = 1
	var timer
	
	var vert_speed = 0.2; var hor_speed = 0.1; var total_speed = 1#randomly set total_speed
	var speed; var base_speed = 1
	var angle = 0; var radius = 10
	
	
	var anchor_pos; var x_delta = 24; var y_delta = 12
	var left_right_bound = Vector2(); var top_down_bound = Vector2()
	var is_moving = false; var moving_left = true; var moving_up = false
	var move_type = "zigzag"#alternative is circular or sinusoidal

	var area; var shape; var circle; var line_anchor
	
	var line; var line_path
	
	signal last_balloon_popped

	func _init():#add params here to update speed etc based on difficulty level
		sprite_frames = load("res://Scenes/MicroGames/MicroGameAssets/PopIt/2D/Animations/BalloonAnim.tres")
		
		timer = Timer.new()
		area = Area2D.new()
		shape = CollisionShape2D.new()
		circle = CircleShape2D.new()
		line_anchor = Marker2D.new()
#needs a path2d and a line2d for the string! also need to position the line anchor!
		add_child(timer)#...why is there a timer??
		add_child(area)
		area.add_child(shape)
		shape.shape = circle
		circle.radius = 16
		shape.position.y = 3
		area.input_pickable = true

		add_child(line_anchor)
		
		gen_color()
		
		area.connect("mouse_entered", Callable(self, "mouse_over"))
		area.connect("mouse_exited", Callable(self, "mouse_exited"))	

#		area.connect("mouse_entered", Callable(self, "mouse_over"))
#		area.connect("mouse_exited", Callable(self, "mouse_exited"))	
	func gen_color():
		var col_r = (randf_range(0.3, 1.0))
		var col_g = (randf_range(0.3, 1.0))
		var col_b = (randf_range(0.3, 1.0))
		self.modulate = Color(col_r, col_g, col_b)

#randomize the placement for purposes of phase...base moving_left off of this

	func _ready():
#		set_process_input(true)
#		connect("is_queued_for_deletion", Callable(get_tree().get_root().get_node("PopIt"),"fuck"))
		set_process_input(true)
		set_process_unhandled_input(true)
		place()
		randomize_move_type()
		set_speed()
	func place():#refactor this to be inside of the balloonhandler, so that
		#it's easier to prevent overlaps.
#12 is the size of the side bar where the bomb goes. x_d
		var offset_x = x_delta+(((scale.x)*(circle.radius)))
		var offset_y
		var anchor_pos_x = randi_range(12+offset_x,228-offset_x)
		var anchor_pos_y = randi_range(0,3)
		anchor_pos_y = 100
#		pos_x = x_delta/2+12+(2*((scale.x)*(circle.radius)))
		anchor_pos = Vector2(anchor_pos_x, anchor_pos_y)
		left_right_bound = Vector2(anchor_pos_x-x_delta, anchor_pos_x+x_delta)
		top_down_bound = Vector2(anchor_pos_y-y_delta,anchor_pos_y+y_delta)
		position = anchor_pos
		var init_pos
	func randomize_phase():
		pass
	func set_speed():
		speed = base_speed*total_speed*Vector2(hor_speed, vert_speed)
		is_moving = true
	func randomize_move_type():
		var my_rand_int = randi_range(0,2)
		match my_rand_int:
			0:
				pass#keeps move_type as the default
			1:
				move_type = "sinusoidal"
			2:
				move_type = "ellipsoid"
#		print(my_rand_int)
	func _process(delta):
		move_around(delta)

	func _unhandled_input(event):
		if can_be_clicked:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if area != null:
						if !area.is_queued_for_deletion():
							pop()
	
	func mouse_over():
		can_be_clicked = true
	func mouse_exited():
		can_be_clicked = false

	func pop():
#		pop sound!
		is_moving = false
		area.queue_free()
		play()#
		for balloon in get_parent().get_children():
			if balloon.is_moving:
#				print(balloon.name + " is moving!")
				break
			else:
				if balloon == get_parent().get_children()[-1]:
					emit_signal("last_balloon_popped")
#		print(str(get_parent().get_children()) + "\n")
		timer.start(pop_time)
		await timer.timeout
		sprite_frames = null
		self.queue_free()
		#for balloon in get_parent().get_children():
			#print(balloon.is_queued_for_deletion())
#		print("\n")
#		print(get_parent().get_children())
		#emit a signal here.
		#play pop_anim, queue_free()
	
	func move_around(delta):
		match move_type:
			"zigzag":
				if is_moving:
					if position.x >= left_right_bound.y:
						moving_left = true
					elif position.x <= left_right_bound.x:
						moving_left = false
					if position.y >= top_down_bound.y:
						moving_up = true
					elif position.y <= top_down_bound.x:
						moving_up = false

					match moving_left:
						true:
							position.x -= hor_speed
						false:
							position.x += hor_speed
					match moving_up:
						true:
							position.y -= vert_speed
						false:
							position.y += vert_speed
			"sinusoidal":
				pass
			"ellipsoid":
				angle += vert_speed # * delta
				var x = radius * cos(angle)
				var y = radius * sin(angle)
				position = Vector2(anchor_pos.x + x, anchor_pos.y + y)
				pass
			"linear":
				pass
#the difficulties for this are the number of balloons and how fast they move around
#the different conditions: a clown, a boy, and air balloons
# Called when the node enters the scene tree for the first time.

class hot_air_balloon extends balloon:
	pass
class string_balloon extends balloon:
	pass

func _set_difficulty(dif):
	match dif:
		"easy":
			num_balloons = 3
			balloons_type = "hot_air"
		"medium":
			num_balloons = 5
			balloons_type = "circus"
		"hard":
			num_balloons = 7
			balloons_type = "birthday"

func _ready():
	boilerplate_ready()
	for balloon in num_balloons:
		spawn_balloon()
	var points = $Path2D.curve.get_baked_points()
#	$BalloonHandler.process_mode = Node.PROCESS_MODE_DISABLED#this line disables the balloon handler and all children, until start is called!
#	print(points)
#	print($Line2D.points)

#	for point in points:
#		$Line2D.add_point(point)
	$Line2D.points = points
#	$Line2D.add_point(Vector2(0,0))
#	print($Line2D.points)
#	for point in points:
#		$Line2D.add_point(point)
#	pass # Replace with function body.
	set_process(true)

#design goal: spawn 1-5 balloons, they move gently from side to 
#side and float up and down just a tiny bit.
#we want to make them have a line connecting them to the hand 
#that simulates a string. on clicking, they pop (want to make sure
#that you can't pop too many at once), and the string goes limp
#and the balloon disappears.

func spawn_balloon():
	var cur_balloon = balloon.new()
	cur_balloon.connect("last_balloon_popped", Callable(self, "on_last_balloon_pop"))
	$BalloonHandler.add_child(cur_balloon)
	cur_balloon.name = "Balloon1"#this ensures that the name increments properly from 1 to 2 to 3 etc

func on_last_balloon_pop():
	end_state = "success"
