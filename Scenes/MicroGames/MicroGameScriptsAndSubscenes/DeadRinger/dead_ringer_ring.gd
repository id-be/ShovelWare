extends CharacterBody2D;

var angle := 0.0;
var theta_step := PI/8;
var amplitude := 64.0;

func _ready() -> void:
	$RingSprite.play("Jiggle");
	velocity = Vector2(160,0);
	set_physics_process(false);

func descend() -> void:
	await get_tree().create_timer(0.01).timeout;
	position.y+=1;
	if global_position.y==get_parent().global_position.y:
		set_physics_process(true);
		$RingSprite.play("Jiggle");
		return;
	descend();

func _physics_process(delta: float) -> void:
	angle += theta_step;
	
	velocity.x = amplitude*cos(angle/20);
	
	if get_slide_collision_count():
		var collider = get_slide_collision(0).get_collider();
		global_position.x = collider.global_position.x;
		if collider.get_child(0).get_parent().name=="StaticBody2D":
			collider.get_child(0).disabled = true;
			velocity.y = 64;
		else:
			$RingSprite.stop();
			$RingSprite.set_frame_and_progress(0,0);
			if collider is CharacterBody2D:
				get_parent().increment_score();
			elif collider.get_child(0) is Sprite2D:
				get_parent().get_parent().set_failure();
			else:
				collider.get_child(0).disabled = true;
				get_parent().increment_score();
			$MainBody.shape.height=12;
			velocity.y=0;
			
			set_physics_process(false);
	move_and_slide();
