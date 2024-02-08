extends microgame

#Constants
const SPEED = 50
const SPEED_STEP = 0.05
const TURN_STEP = 0.05

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

func _ready():
	#boilerplate_ready()
	difficulty = "hard"
	
	#Set laser and point on.
	laser.get_node("LaserParticles2D").emitting = true
	pointer.get_node("PointerParticles2D").emitting = true
	for crate in $Crates.get_children():
		#Connect crate's "break" animation to increase_score function
		crate.get_node("AnimationPlayer").animation_started.connect(Callable(self,"increase_score"))
		crate.get_node("AnimationPlayer").play("idle")
		
	#$CatSound.play()
	#Set up cat and crate positions based on difficulty.
	$Loadouts.play(difficulty)
	
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
	
	
func _physics_process(delta):
	#Constantly update laser position
	laser.global_position = get_global_mouse_position()
	pointer.look_at(laser.global_position)
	get_node("PointerLine2D").points[0] = get_node("Pointer/PointerParticles2D").global_position
	get_node("PointerLine2D").points[1] = laser.global_position
	
	if cat_chasing:
		#IF NOTICE LASER
		#Sorry I know this is messy.
		cat_sprite.play("walk")
		var new_velocity = cat.global_position.direction_to(laser.global_position) * SPEED
		cat.velocity = lerp(cat.velocity, new_velocity, SPEED_STEP)
		cat.move_and_slide()
		var new_rotation = cat.global_position.angle_to(laser.global_position)
		var v = laser.global_position - cat.global_position
		var angle = v.angle()
		var r = cat.global_rotation
		cat.global_rotation = lerp_angle(r, angle, TURN_STEP)
		if cat_attacking:
			cat_sprite.play("attack_pounce")
			var collider = cat_ray.get_collider()
			if collider:
				if "Crate" in collider.name:
					if laser.global_position.distance_to(cat.global_position) > 50:
						cat_chasing = false
						return
					else:
						if collider.get_node("AnimationPlayer").current_animation == "highlighted":
							collider.get_node("AnimationPlayer").play("break")
		if laser.global_position.distance_to(cat.global_position) <= 50:
			cat_attacking = true
		else:
			cat_attacking = false

	else:
		#IF NOT NOTICE LASER
		cat_sprite.play("idle")
		
#SIGNALS
func _on_animated_sprite_2d_animation_finished():
	#End cat's attacking state after pounce animation completed.
	if cat_sprite.animation == "attack_pounce":
		cat_attacking = false

func _on_detect_area_2d_area_entered(area):
	#Make cat chase laser
	if area == laser:
		#var collider = cat_ray.get_collider()
		#if collider:
			#if "Crate" in collider.name:
				#if laser.global_position.distance_to(cat.global_position) > 50:
					#cat_chasing = false
					#return
		cat_chasing = true

func _on_undetect_area_2d_area_exited(area):
	#If laser leaves undetect area, cat no longer chases it. 
	if area.name == "Laser":
		cat_chasing = false
		
func _on_laser_body_entered(body):
	if "Crate" in body.name:
		if body.get_node("AnimationPlayer").current_animation != "break":
			#Highlighted is like a staging state for the crate designating it
			#as breakable. It's meant to prevent the cat from breaking it unless
			#it's actually looking at the thing. 
			body.get_node("AnimationPlayer").play("highlighted")
			
func _on_laser_body_exited(body):
	if "Crate" in body.name:
		if body.get_node("AnimationPlayer").current_animation != "break":
			body.get_node("AnimationPlayer").play("idle")




