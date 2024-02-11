extends microgame

#Constants
const SPEED = 50
const SPEED_STEP = 0.05
const TURN_STEP = 0.05

#Adjustable export variables
@export_range(25, 200) var speed: int = 60
@export_range(0.01, 0.20) var speed_step: float = 0.05
@export_range(0.01, 0.20) var turn_step: float = 0.05
@export_range(5, 20) var attack_radius: int = 30

#Scene node variables
@onready var cat = $Cat
@onready var cat_sprite = $Cat/AnimatedSprite2D
@onready var cat_ray = $Cat/RayCast2D
@onready var laser = $Laser
@onready var pointer = $Pointer
@onready var crates = $Crates

#State variable(s)
var cat_chasing = false
var cat_attacking = false
var score = 0
var target = null
var target_pos = Vector2.ZERO
var box_to_break = null

func _ready():
	boilerplate_ready()
	
	#DEBUG STUFF, COMMENT OUT WHEN NOT DEBUGGING
	#AND UNCOMMENT ABOVE boilerplate_ready()
	#_set_difficulty("hard")
	#$DebugCamera2DDisable.enabled = true
	#laser.get_node("LaserParticles2D").emitting = true
	#pointer.get_node("PointerParticles2D").emitting = true
	
func _set_difficulty(dif):
	$Loadouts.play(dif)
	
func _start():
	boiler_plate_start()
	
	#Set laser and point on.
	laser.get_node("LaserParticles2D").emitting = true
	pointer.get_node("PointerParticles2D").emitting = true
	for crate in $Crates.get_children():
		#Connect crate's "break" animation to increase_score function
		crate.get_node("AnimationPlayer").animation_started.connect(Callable(self,"increase_score"))
		crate.get_node("AnimationPlayer").play("idle")
	$CatSound.play()
	
func increase_score(anim):
	if anim != "break":
		return
	score += 1
	if score == 2:
		if difficulty in ["easy","medium"]:
			end_state = "success"
	elif score == 3:
		if difficulty == "hard":
			end_state = "success"
	
func _physics_process(_delta):
	#Constantly update laser position
	laser.global_position = get_global_mouse_position()
	pointer.look_at(laser.global_position)
	get_node("PointerLine2D").points[0] = get_node("Pointer/PointerParticles2D").global_position
	get_node("PointerLine2D").points[1] = laser.global_position
	
	if cat_chasing:
		if target:
			#update target position (either laser or crate)
			target_pos = target.global_position
		else:
			#if no target, cat cannot be chasing
			cat_chasing = false
			return
		
		if cat_attacking:
			if target_pos.distance_to(cat.global_position) <= attack_radius:
				if cat_sprite.animation != "attack_pounce":
					#don't want to play attack animation if it's already playing
					cat_sprite.play("attack_pounce")
				#return to prevent below code from executing
				return
		
		#if chasing but not attacking, play walk animation
		cat_sprite.play("walk")
		
		#cat's velocity
		var new_velocity = cat.global_position.direction_to(target_pos) * speed
		cat.velocity = lerp(cat.velocity, new_velocity, speed_step)
		cat.move_and_slide()
		
		#cat's rotation
		var new_rotation = cat.global_position.angle_to(target.global_position)
		var v = target_pos - cat.global_position
		var angle = v.angle()
		var r = cat.global_rotation
		cat.global_rotation = lerp_angle(r, angle, turn_step)
		
		#check if a crate is detected
		if cat_ray.is_colliding():
			var collider = cat_ray.get_collider()
			if "Crate" in collider.name:
				if collider.get_node("AnimationPlayer").current_animation != "break":
					#change target from laser to crate/box
					target = collider
					box_to_break = collider
					#set attacking state on. will prevent chasing movement during attack.
					cat_attacking = true
					return
	else:
		#if cat is not chasing or attacking, it's idle. 
		if !cat_attacking:
			cat_sprite.play("idle")
		
func _on_animated_sprite_2d_animation_finished():	
	#End cat's attacking state after pounce animation completed.
	if cat_sprite.animation == "attack_pounce":
		#if no box to break anymore, forget it
		if !box_to_break:
			return
		box_to_break.get_node("AnimationPlayer").play("break")
		#after playing the box's break animation, make cat forget about it
		#and to focus on the laser again
		box_to_break = null
		target = laser
		cat_attacking = false

func _on_detect_area_2d_area_entered(area):
	#Make cat chase laser once it's detected
	if area == laser:
		target = laser
		cat_chasing = true

func _on_undetect_area_2d_area_exited(area):
	return
	#can probably be disconnected and deleted, overkill for this game.
