extends microgame


#Adjustable export variables
@export_range(25, 200) var speed: int = 60

#Scene node variables
@onready var dragon = $Path/DragonFollowPath/Dragon
@onready var dragon_anim = $Path/DragonFollowPath/Dragon/DragonAnimationPlayer
@onready var castle = $Castle
@onready var castle_anim = $Castle/CastleAnimationPlayer
@onready var dragon_path = $Path/DragonFollowPath
@onready var cursor_path = $Path/CursorFollowPath
@onready var loadouts = $Loadouts
@onready var timer_gen_path = $GeneratePathTimer
@onready var timer_gen_point = $GeneratePathTimer/GeneratePointTimer

#State variable(s)
var dragging = true
var chasing = false
var attacking = false
var score = 0


func _ready():
	#boilerplate_ready()
	
	pass
	
func _set_difficulty(dif):
	loadouts.play(dif)
	
func _start():
	boiler_plate_start()
	

	#castle.get_node("AnimationPlayer").animation_started.connect(Callable(self,"increase_score"))
	castle.get_node("AnimationPlayer").play("normal")
	$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D.disabled = true
	
func increase_score():
	end_state = "success"
		
func _unhandled_input(event):
	if dragging:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					cursor_path.show()
					timer_gen_path.start()
					timer_gen_point.start()
				else:
					if timer_gen_path.time_left > 0:
						timer_gen_path.stop()
						timer_gen_path.emit_signal("timeout")
	
func _physics_process(delta):
	if !dragging:
		if chasing:
			if dragon.global_position.x >= castle.global_position.x - 30:
				
				$Path/DragonFollowPath/Dragon/Breath.play()
				attacking = true
			#follow along path

		if attacking:
			if dragon.global_position.x >= castle.global_position.x + 30:
				attacking = false
			#produce flame
		dragon_path.set_progress(dragon_path.get_progress() + (speed * delta))

func _on_detect_area_area_entered(area):
	area.set_deferred("monitoring", false)
	area.set_deferred("monitorable", false)
	area.hide()


func _on_generate_path_timer_timeout():
	dragging = false
	chasing = true
	cursor_path.hide()
	#dragon_path.show()
	#set pathfollow points to generated array. 
	#step timer subtimer of this one. 

func _on_generate_point_timer_timeout():
	if timer_gen_path.time_left > 0:
		var nextpos = get_global_mouse_position()
		$Path.curve.add_point(nextpos)
		cursor_path.set_progress_ratio(100)
		timer_gen_point.start()
	else:
		$Path.curve.add_point(castle.position + Vector2(200, 0))
		timer_gen_point.stop()
	


func _on_attack_area_area_entered(area):
	if area == $Castle/CastleArea2D:
		increase_score()
		if $Path/DragonFollowPath/Dragon/Breath.is_playing():
			castle_anim.play("Burning")
		else:
			var timer = Timer.new()
			timer.start(0.2)
			await timer.timeout
			castle_anim.play("Burning")
			
			

func _on_breath_animation_finished():
	attacking = false

func _on_breath_frame_changed():
	if $Path/DragonFollowPath/Dragon/Breath.frame >= 3:
		$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D.disabled = false
