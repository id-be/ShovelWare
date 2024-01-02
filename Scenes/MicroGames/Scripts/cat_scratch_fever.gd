extends microgame

const CAT_SPEED = 100
const CAT_STEP = 0.05

@onready var cat = $Cat
@onready var cat_sprite = $Cat/AnimatedSprite2D

func _ready():
	pass
	
func _physics_process(delta):
	var target = get_global_mouse_position()
	var new_velocity = cat.global_position.direction_to(target) * CAT_SPEED
	cat.velocity = lerp(cat.velocity, new_velocity, CAT_STEP)
	cat.move_and_slide()
	var new_rotation = cat_sprite.rotation.angle_to(target)
	cat_sprite.rotation = lerp_angle(cat_sprite.rotation, new_rotation, CAT_STEP)
	
	
	
	print(cat.velocity.length())
	
