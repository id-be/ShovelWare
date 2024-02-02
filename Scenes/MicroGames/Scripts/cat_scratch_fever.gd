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

func _ready():
	#Set laser and point on.
	laser.get_node("LaserParticles2D").emitting = true
	pointer.get_node("PointerParticles2D").emitting = true
	for crate in $Crates.get_children():
		crate.get_node("AnimationPlayer").play("idle")
	
func _physics_process(delta):
	laser.global_position = get_global_mouse_position()
	pointer.look_at(laser.global_position)
	get_node("PointerLine2D").points[0] = get_node("Pointer/PointerParticles2D").global_position
	get_node("PointerLine2D").points[1] = laser.global_position
	
	if cat_chasing:
		#IF NOTICE LASER
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
					if laser.global_position.distance_to(cat.global_position) > 30:
						cat_chasing = false
						return
					else:
						
						print(collider.get_node("AnimationPlayer").current_animation)
						if collider.get_node("AnimationPlayer").current_animation == "highlighted":
							collider.get_node("AnimationPlayer").play("break")
				

		if laser.global_position.distance_to(cat.global_position) <= 30:
			cat_attacking = true
		else:
			cat_attacking = false

		

			
	
		#print(cat.velocity.length())
	else:
		#IF NOT NOTICE LASER
		cat_sprite.play("idle")
	

func _on_detect_area_2d_area_entered(area):
	if area == laser:
		var collider = cat_ray.get_collider()
		if collider:
			if "Crate" in collider.name:
				if laser.global_position.distance_to(cat.global_position) > 30:
					cat_chasing = false
					return
		cat_chasing = true
	

func _on_undetect_area_2d_area_exited(area):
	if area.name == "Laser":
		cat_chasing = false
		



func _on_laser_body_entered(body):
	
	if "Crate" in body.name:
		print('asdf')
		if body.get_node("AnimationPlayer").current_animation != "break":
			body.get_node("AnimationPlayer").play("highlighted")


func _on_laser_body_exited(body):
	if "Crate" in body.name:
		if body.get_node("AnimationPlayer").current_animation != "break":
			body.get_node("AnimationPlayer").play("idle")


func _on_still_in_focus_timer_timeout():
	if $Cat/DetectArea2D.overlaps_area($Laser):
		var collider = cat_ray.get_collider()
		if !collider || laser.global_position.distance_to(cat.global_position) <= 30:
			_on_detect_area_2d_area_entered($Laser)
		else:
			cat_chasing = false
		


func _on_animated_sprite_2d_animation_finished():
	if cat_sprite.animation == "attack_pounce":
		cat_attacking = false
