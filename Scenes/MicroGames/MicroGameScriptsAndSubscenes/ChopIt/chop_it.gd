extends microgame

@export var carrot_chunk_count := 0;
var current_carrot_chunk;
var middle_chunk_count = 15;
var target_chunk_count = 0;

func _set_difficulty(dif) -> void:
	match dif:
		"easy":
			carrot_chunk_count = 20-1;
		"medium":
			carrot_chunk_count = 27-1;
		"hard":
			carrot_chunk_count = 32-1;
	target_chunk_count = carrot_chunk_count;
	middle_chunk_count = carrot_chunk_count - middle_chunk_count;
	carrot_chunk_count = 0;
	spawn_carrot();

func spawn_carrot() -> void:
	var mid_start_chunk_pos;
	var cur_chunk_pos = 0;
	var chunk_count = 0;
	var final_chunks = $Carrot.get_children().slice(27,33);
	for chunk in $Carrot.get_children().slice(9,27):
		if chunk_count == 0:
			mid_start_chunk_pos = chunk.position;
		if chunk_count < middle_chunk_count:
			chunk_count += 1;
			chunk.position.x += cur_chunk_pos;
			cur_chunk_pos += 8;
			$Carrot.position.x -= 8;
		else:
			chunk.queue_free();
	cur_chunk_pos -= 8;
	for chunk in final_chunks:
		chunk.position.x += cur_chunk_pos;

func _process(delta) -> void:
	if carrot_chunk_count == target_chunk_count-1 && $ChefSprite.modulate.a < 1:
		end_state = "success";
		pop_up_chef();
		return
	if Input.is_action_just_pressed("button_1"):
		carrot_chunk_count += 1;
		carrot_return();

func carrot_return() -> void:
	if $Carrot.get_children().size() > 0:
		var child = $Carrot.get_children()[-1];
		child.reparent(self, true);
		child.chop();
		$AudioStreamPlayer.play(0.25);

		$Carrot.position.x += 8;

func pop_up_chef() -> void:
	while $ChefSprite.modulate.a <= 1:
		await get_tree().create_timer(0.1).timeout
		$ChefSprite.modulate.a += 0.1	
	$AudioStreamPlayer2.play(.19)
