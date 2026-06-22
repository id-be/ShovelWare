extends microgame;

var num_fingers_down := 0;
var score := 0;
var current_fingers = [];

func _ready() -> void:
	randomize_fingers();

func _set_difficulty(dif) -> void:
	match dif:
		"easy":
			num_fingers_down = 1;
		"medium":
			num_fingers_down = 2;
		"hard":
			num_fingers_down = 3;

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("button_1"):
		drop_ring();

func _start() -> void:
	#boilerplate_start();
	$HandAndThumb.play("Close");
	$RingHandler/Ring.set_physics_process(true);

func randomize_fingers() -> void:
	var finger_list = $HandAndThumb.get_children();
	
	for finger in num_fingers_down:
		var cur_finger_int = randi_range(0,finger_list.size()-1);
		finger_list[cur_finger_int].play("Close");
		finger_list.pop_at(cur_finger_int);
	for finger in finger_list:
		current_fingers.append(finger);
		finger.get_child(0).get_child(0).disabled = false;
		finger.get_child(1).get_child(0).disabled = false;

func increment_score():
	score += 1;
	if is_boss:
		if score >= 3:
			end_state="boss_success";
			await get_tree().create_timer(2).timeout;
			_end_game();
		else:
			$RingHandler.spawn_ring();
	else:
		if score >=1:
			end_state = "success";
	for finger in current_fingers:
		finger.get_child(0).get_child(0).disabled = false;

func set_failure() -> void:
	if is_boss:
		end_state="boss_failure";
		$RingHandler.hide();
		await get_tree().create_timer(2).timeout;
		_end_game();
	else:
		end_state="failure";
	

func _on_hand_and_thumb_frame_changed() -> void:
	if $HandAndThumb.frame==3:
		$HandAndThumb/IndexFinger.show();
		$HandAndThumb/MiddleFinger.show();
		$HandAndThumb/RingFinger.show();
		$HandAndThumb/PinkyFinger.show();

func drop_ring() -> void:
	for child in $RingHandler.get_children():
		child.amplitude=0;
		child.velocity=Vector2(0,64);
