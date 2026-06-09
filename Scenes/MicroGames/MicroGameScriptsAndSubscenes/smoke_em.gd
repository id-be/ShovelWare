extends microgame

@export var drags := 15;#20,25
var cur_num_drags := 0;

func _set_difficulty(dif):
	match dif:
		"easy":
			drags = 15;
		"medium":
			drags = 20;
		"hard":
			drags = 25;

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("button_1"):
		shorten_cigarette()

func shorten_cigarette():
	cur_num_drags += 1;
	$Line2D.points[-1] = lerp($Line2D.points[-1],$Line2D.points[0],0.5*float(cur_num_drags)/float(drags));
	$SmokeParticles.position = $Line2D.points[-1]
	$CherryParticles.position = $Line2D.points[-1]
	if cur_num_drags == drags:
		end_state = "success"
		Globals.stop_music()
		$AudioStreamPlayer.play()
		$SmokeParticles.hide()
		$CherryParticles.hide()
