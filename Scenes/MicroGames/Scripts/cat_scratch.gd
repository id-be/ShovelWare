extends microgame

#Constants
const SPEED = 50
const SPEED_STEP = 0.05
const TURN_STEP = 0.05

@export_range(25, 200) var speed: int = 60
@export_range(0.01, 0.20) var speed_step: float = 0.05
@export_range(0.01, 0.20) var turn_step: float = 0.05
#@export_range(5, 100) var detect_radius: int = 70
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
	#boilerplate_ready()
	
	_set_difficulty("hard")
	
	#$DebugCamera2DDisable.enabled = false
	
	
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
	
	if target:
		target_pos = target.global_position
	else:
		cat_chasing = false
	

	if cat_chasing:
		if !target:
			cat_chasing = false
			return
		
		if cat_attacking:
			if target_pos.distance_to(cat.global_position) <= attack_radius:
				if cat_sprite.animation != "attack_pounce":
					cat_sprite.play("attack_pounce")
				return
			#if target_pos.distance_to(cat.global_position) <= attack_radius:
		
		cat_sprite.play("walk")
		var new_velocity = cat.global_position.direction_to(target_pos) * speed
		cat.velocity = lerp(cat.velocity, new_velocity, speed_step)
		cat.move_and_slide()
		var new_rotation = cat.global_position.angle_to(target.global_position)
		var v = target_pos - cat.global_position
		var angle = v.angle()
		var r = cat.global_rotation
		cat.global_rotation = lerp_angle(r, angle, turn_step)
		
		if cat_ray.is_colliding():
			var collider = cat_ray.get_collider()
			if "Crate" in collider.name:
				#target = collider
				#target_pos = target.global_position
				#cat_sprite.play("attack_pounce")
				target = collider
				box_to_break = collider
				cat_attacking = true
				return
				#if target_pos.distance_to(cat.global_position) <= detect_radius:
				
		#else:
			#cat_attacking = false

	else:
		if !cat_attacking:
		#IF NOT NOTICE LASER
			cat_sprite.play("idle")
		
#SIGNALS
func _on_animated_sprite_2d_animation_finished():
	print(cat_sprite.animation)
	if !box_to_break:
		return
	#End cat's attacking state after pounce animation completed.
	if cat_sprite.animation == "attack_pounce":
		#if box_to_break.get_node("AnimationPlayer").current_animation != "break":
			#box_to_break("CollisionShape2D").disabled = true
		#if box_to_break.get_node("Sprite2D").frame != 27:
		box_to_break.get_node("AnimationPlayer").play("break")
		box_to_break = null
		
		cat_attacking = false
		target = laser
			#_on_detect_area_2d_area_entered(laser)

func _on_detect_area_2d_area_entered(area):
	#Make cat chase laser
	if area == laser:
		target = laser
		cat_chasing = true

func _on_undetect_area_2d_area_exited(area):
	#If laser leaves undetect area, cat no longer chases it. 
	if area == laser:
		#if !cat_attacking:
		target = null
			#cat_chasing = false




