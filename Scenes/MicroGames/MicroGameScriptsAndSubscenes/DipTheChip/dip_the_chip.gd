extends microgame

func _ready() -> void:
	pass;

func _start() -> void:
	$ChipDip.set_physics_process(true);

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("button_1"):
		$ChipDip.descend()

func _set_difficulty(dif):
	match dif:
		"easy":
			$ChipDip.amplitude = 48
		"medium":
			$ChipDip.amplitude = 64
		"hard":
			$ChipDip.amplitude = 64
			$ChipDip.theta_step = PI/4
			$DipTop.scale = 0.8*$DipTop.scale
			$DipTop/DipBottom.scale = 0.8*$DipTop/DipBottom.scale
