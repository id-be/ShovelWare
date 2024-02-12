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
@onready var dragon = $Dragon
@onready var dragon_anim = $Dragon/AnimationPlayer
@onready var castle = $Castle

#State variable(s)
var chasing = false
var attacking = false
var score = 0
var dragon_path_points = []

func _ready():
	#boilerplate_ready()
	
	pass
	
func _set_difficulty(dif):
	$Loadouts.play(dif)
	
func _start():
	boiler_plate_start()
	
	for castle in $Castles.get_children():
		#Connect crate's "break" animation to increase_score function
		castle.get_node("AnimationPlayer").animation_started.connect(Callable(self,"increase_score"))
		castle.get_node("AnimationPlayer").play("normal")
	$CatSound.play()
	
func increase_score(anim):
	if anim != "burning":
		return
	score += 1
	if score >= 1:
		end_state = "success"
		
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Left button was clicked at ", event.position)
			else:
				print("Left button was released at", event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("Wheel down")
	
func _physics_process(_delta):
	
	if chasing:
		dragon_anim.play("fly")
		#follow along path
		
	if attacking:
		pass
		#produce flame

func _on_detect_area_area_entered(area):
	#dragon gets hit with bolt
	pass # Replace with function body.


func _on_generate_path_timer_timeout():
	chasing = true
	#set pathfollow points to generated array. 
	#step timer subtimer of this one. 

func _on_generate_point_timer_timeout():
	var nextpos = get_global_mouse_position()

	$GeneratePathTimer/GeneratePointTimer.start()
