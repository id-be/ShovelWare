extends CharacterBody2D

var angle := 0.0;
var theta_step := PI/8;
var amplitude := 64#3000#0.03000.0;#64

func _process(delta: float) -> void:
	angle += theta_step;
	
	velocity.x = amplitude*cos(angle/20);
	
	if get_slide_collision_count():
		var collider = get_slide_collision(0).get_collider();
		#global_position.x = collider.global_position.x;
		if collider.get_child(0).get_parent().name=="StaticBody2D":
			#collider.get_child(0).disabled = true;
			velocity.y = 64;
			pass
		else:
			#$RingSprite.stop();
			#$RingSprite.set_frame_and_progress(0,0);
			if collider is CharacterBody2D:
				#get_parent().increment_score();
				pass
			elif collider.get_child(0) is Sprite2D:
				#get_parent().get_parent().set_failure();
				pass
			else:
				#collider.get_child(0).disabled = true;
				#get_parent().increment_score();
				pass
			#$MainBody.shape.height=12;
			#velocity.y=0;
			
			#set_physics_process(false);
	move_and_slide();
	
func descend() -> void:
	amplitude=0
	await get_tree().create_timer(0.01).timeout;
	if get_slide_collision_count():
		if get_slide_collision(0).get_collider().get_parent().name == "DipTop":
			#print(get_slide_collision(0).get_collider_shape().name)
			if get_slide_collision(0).get_collider_shape().name =="CollisionShape2D":
				get_parent().end_state = "success"
				return
	global_position.y+=2;
	if global_position.y==get_parent().global_position.y:
		set_physics_process(true);
		return;
	descend();
