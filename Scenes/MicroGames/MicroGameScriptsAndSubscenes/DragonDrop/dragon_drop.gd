extends microgame;

#Adjustable export variables
@export_range(25, 360) var speed: int = 60;
#Scene node variables
@onready var dragon = $Path/DragonFollowPath/Dragon;
@onready var dragon_anim = $Path/DragonFollowPath/Dragon/DragonAnimationPlayer;
@onready var castle = $Castle;
@onready var castle_anim = $Castle/CastleAnimationPlayer;
@onready var dragon_path = $Path/DragonFollowPath;
@onready var cursor_path = $Path/CursorFollowPath;
@onready var loadouts = $Loadouts;
@onready var timer_gen_path = $GeneratePathTimer;
@onready var timer_gen_point = $GeneratePathTimer/GeneratePointTimer;

#State variable(s)
var dragging = true;
var chasing = false;
var attacking = false;
var score = 0;


func _ready() -> void:
	pass
	
func _set_difficulty(dif) -> void:
	#change this to semi-randomize the crossbow positions
	match dif:
		"easy":
			var pos_y = randi_range(0,1);
			var x_offset = randi_range(-42,42);

		"medium":
			var pos_y_1 = randi_range(0,1);
			var x_offset_1 = randi_range(-12,12);
			var pos_y_2 = randi_range(0,1);
			var x_offset_2 = randi_range(-12,12);
			$Ballista1.position = Vector2(81+x_offset_1,58+pos_y_1*36);
			pos_y_1 = randi_range(0,1);
			
			if pos_y_1==1:
				$Ballista1.scale.y=$Ballista1.scale.y*(-1);
			$Ballista2.position = Vector2(142+x_offset_2,58+pos_y_2*36);
			pos_y_2 = randi_range(0,1);
			$Ballista2.scale.y=$Ballista2.scale.y*pow((-1), pos_y_2);
			
			$Ballista3.position = Vector2(-79,108);
		"hard":
			var pos_y_1 = randi_range(0,1);
			var pos_y_2 = randi_range(0,1);
			var pos_y_3 = randi_range(0,1);
			$Ballista1.position = Vector2(69,58+pos_y_1*36);
			$Ballista1.scale.y = $Ballista1.scale.y*pow((-1),pos_y_1);
			$Ballista2.position = Vector2(119 ,58+pos_y_2*36);
			$Ballista2.scale.y = $Ballista2.scale.y*pow((-1),pos_y_2);
			$Ballista3.position = Vector2(169,58+pos_y_3*36);
			$Ballista3.scale.y = $Ballista3.scale.y*pow((-1),pos_y_3);
	#$Loadouts.play(dif)
	
func _start() -> void:
	#boilerplate_start();
	

	#castle.get_node("AnimationPlayer").animation_started.connect(Callable(self,"increase_score"))
	$Castle.get_node("CastleAnimationPlayer").play("Normal");
	$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D.disabled = true;
	$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D2.disabled = true;
	
func increase_score() -> void:
	end_state = "success";
		
func _unhandled_input(event) -> void:
	if dragging:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					cursor_path.show();
					timer_gen_path.start();
					timer_gen_point.start();
				else:
					if timer_gen_path.time_left > 0:
						timer_gen_path.stop();
						timer_gen_path.emit_signal("timeout");
	
func _physics_process(delta) -> void:
	if !dragging:
		if chasing:
			if dragon.global_position.x >= castle.global_position.x - 30:
				
				$Path/DragonFollowPath/Dragon/Breath.play();
				if !$DragonSound.playing:
					$DragonSound.play();
				
				attacking = true;
			#follow along path

		if attacking:
			if dragon.global_position.x >= castle.global_position.x + 30:
				attacking = false;
				
			#produce flame
		dragon_path.set_progress(dragon_path.get_progress() + (speed * delta));

func _on_detect_area_area_entered(area) -> void:

	#area.set_deferred("monitoring", false)
	#area.set_deferred("monitorable", false)
#	area.hide()
	pass


func _on_generate_path_timer_timeout() -> void:
	dragging = false;
	chasing = true;
	cursor_path.hide();
	#dragon_path.show()
	#set pathfollow points to generated array. 
	#step timer subtimer of this one. 

func _on_generate_point_timer_timeout() -> void:
	if timer_gen_path.time_left > 0:
		var nextpos =get_viewport().get_mouse_position();
		$Path.curve.add_point(nextpos);
		cursor_path.set_progress_ratio(100);
		timer_gen_point.start();
	else:
		$Path.curve.add_point(castle.position + Vector2(200, 0));
		timer_gen_point.stop();
	


func _on_attack_area_area_entered(area) -> void:
	if area == $Castle/CastleArea2D:
		increase_score();
		castle_anim.play("Burning");
		
		#if $Path/DragonFollowPath/Dragon/Breath.is_playing():
			#castle_anim.play("Burning")
		#else:
			#var timer = Timer.new()
			#timer.start(0.2)
			#await timer.timeout
			#castle_anim.play("Burning")
			
			

func _on_breath_animation_finished() -> void:
	attacking = false;

func _on_breath_frame_changed() -> void:
	if $Path/DragonFollowPath/Dragon/Breath.frame >= 0:
		$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D.disabled = false;
		$Path/DragonFollowPath/Dragon/AttackArea/CollisionShape2D2.disabled = false;
