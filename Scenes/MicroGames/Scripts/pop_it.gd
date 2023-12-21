extends microgame

var can_click

#	16 wide. 12 is the min, 236-8=228 is the max. so we need to
#	make this balloon placed such that its position is between
#	extents+12 and 228-extents
class dummy extends Sprite2D:
	func _init():
		texture = load("res://Assets/GodotDefaults/icon.svg")
	
	


class balloon extends AnimatedSprite2D:
	var can_be_clicked = false
	var pop_time = 1
	var timer
	
	var vert_speed = 0.2; var hor_speed = 0.1; var total_speed = 1#randomly set total_speed
	var speed; var base_speed = 1
	
	var anchor_pos; var x_delta = 24; var y_delta = 12
	var left_right_bound = Vector2(); var top_down_bound = Vector2()
	var is_moving = false; var moving_left = true; var moving_up = false

	var area; var shape; var circle; var line_anchor
	
	var line; var line_path

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
		area.input_pickable = true
		shape.shape = circle
		circle.radius = 16
		shape.position.y = 3
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
		set_speed()
	func place():
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
	func set_speed():
		speed = base_speed*total_speed*Vector2(hor_speed, vert_speed)
		is_moving = true
	func _process(delta):
		move_around()
	func _input(event):
		if can_be_clicked:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if area != null:
						if !area.is_queued_for_deletion():
							pop()	
	func _unhandled_input(event):
		if can_be_clicked:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if area != null:
						if !area.is_queued_for_deletion():
							pop()	
	#func _input(event):
		#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#if get_rect().has_point((to_local(event.position))):
				#pass
	#func _unhandled_input(event):
		#if can_be_clicked:
			#if event is InputEventMouseButton:
				#if event.button_index == MOUSE_BUTTON_LEFT:
					#if area != null:
						#if !area.is_queued_for_deletion():
							#pop()
	
	func mouse_over():
		print("MOUSEOVER")
		can_be_clicked = true
	func mouse_exited():
		print("MOUSEOFF")
		can_be_clicked = false

	func pop():
		is_moving = false
		area.queue_free()
		play()
		timer.start(pop_time)
		await timer.timeout
		sprite_frames = null
		
		#play pop_anim, queue_free()
	
	func move_around():
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
#the difficulties for this are the number of balloons and how fast they move around
#the different conditions: a clown, a boy, and air balloons
# Called when the node enters the scene tree for the first time.

func _init():
	prompt = "Pop!"

func _ready():
	boilerplate_ready()
	spawn_balloon()
#	spawn_balloon()
#	spawn_balloon()
	var points = $Path2D.curve.get_baked_points()
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

func _input(event):
	return
	if Input.is_action_just_pressed("button_0"):
		print("FACK " + str(get_global_mouse_position()))
		print(get_local_mouse_position())

	#if event is InputEventMouse:
		#var container = find_parent("SubViewPortContainer") as SubViewportContainer
		#if container != null:
			#print("ASS")
			#event = container.make_input_local(event)
		#event = make_input_local(event)0000
	#if can_click:
		#if event is InputEventMouseButton:
			#if event.button_index == MOUSE_BUTTON_LEFT:
				#can_click = false
				
func _unhandled_input(event):
	return
	if Input.is_action_just_pressed("button_0"):
		print("FACK " + str(get_global_mouse_position()))
		print("GAY " + str(get_parent().get_mouse_position()))

	if event is InputEventMouse:
		var container = get_parent().get_parent() as SubViewportContainer
#		print("the container is " + str(container))
		if container != null:
			#print("ASS")
			event = container.make_input_local(event)
		event = make_input_local(event)
	if can_click:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				can_click = false
#design goal: spawn 1-5 balloons, they move gently from side to 
#side and float up and down just a tiny bit.
#we want to make them have a line connecting them to the hand 
#that simulates a string. on clicking, they pop (want to make sure
#that you can't pop too many at once), and the string goes limp
#and the balloon disappears.

func spawn_balloon():
	var cur_balloon = balloon.new()
	$BalloonHandler.add_child(cur_balloon)
	cur_balloon.name = "Balloon1"#this ensures that the name increments properly from 1 to 2 to 3 etc

func fuck():
	print("Hmm")

func move_balloons_around():
	pass


func move_points_around():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_mouse_entered():
	can_click = true
	print(get_global_mouse_position())
	

func _on_area_2d_mouse_exited():
	can_click = false
	print("Ahh")

