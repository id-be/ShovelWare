extends microgame

@export_range(5,12) var combo_length: int = 5
var game_inputs = []
var max_num_inputs

var game_input_glyphs = []
var temp_game_inputs = []
var cur_input_index = 0

var cur_combo = []

var is_comboing = true
# Called when the node enters the scene tree for the first time.
func _ready():
	boilerplate_ready()
	max_num_inputs = game_inputs.size() - 1
	for input in input_flags.keys():
		if input_flags[input]:
			game_inputs.append(input)
	randomize_fighters()
	randomize_bg()
	generate_combo()
	print(game_inputs)
#	print(InputMap.get_actions())

func _input(event):
	var action_as_string
#	print(event.is_action_type())
#	print("FUCK")
	if is_comboing:
		for input in game_inputs:
			if Input.is_action_just_pressed(input) && Input.is_action_just_pressed(cur_combo[cur_input_index]):
				if cur_input_index == combo_length - 1:
					is_comboing = false
					$Label3.show()
					end_state = "success"
					flash_and_disappear_combo()
				cur_input_index += 1
				$Label2.visible_characters = cur_input_index
			elif Input.is_action_just_pressed(input):
				is_comboing = false
				$Label4.show()
	

#	print(InputMap.event_is_action(event, action_as_string))
#	print(event.as_text())

func generate_combo():
	cur_input_index = 0
	var new_combo = []
	var new_glyph_combo = []
	var last_input
	for input in combo_length:
		temp_game_inputs = game_inputs.duplicate()
		temp_game_inputs.shuffle()
		var next_input = temp_game_inputs.pop_back()
		if new_combo.size() > 0:
			last_input = new_combo[-1]
		if last_input == next_input:
			next_input = temp_game_inputs.pop_back()
#		print(temp_game_inputs)
		new_combo.append(next_input)
	for unparsed_input in new_combo:
		match unparsed_input:
			"button_0":
				new_glyph_combo.append("⓿")
			"button_1":
				new_glyph_combo.append("⓵")
			"ui_up":
				new_glyph_combo.append("⏶")
			"ui_down":
				new_glyph_combo.append("⏷")
			"ui_left":
				new_glyph_combo.append("⏴")
			"ui_right":
				new_glyph_combo.append("⏵")
#	print(new_glyph_combo)
#	print(new_combo)
	cur_combo = new_combo
	var my_label_text = ""
	for glyph in new_glyph_combo:
		my_label_text += glyph
	$Label.text = my_label_text; $Label.show()
	$Label2.text = my_label_text; $Label2.visible_characters = 0; $Label2.show()
		#
		#if is_truncated:
			#temp_game_inputs = game_inputs.duplicate()
			#is_truncated = false
		#new_combo.append(temp_game_inputs[rand_input])
#	print(new_combo)
		#temp_game_inputs.shuffle()
#for input in combo_length:
		#
		#pass
	
	#for input in temp_game_inputs:
		#print(input)
#⓿⓵ == 0,1
#≺≻≼≽ == left, up, right, down
#⏴⏵⏶⏷ == left, right, up, down
# Called every frame. 'delta' is the elapsed time since the previous frame.
func randomize_fighters():
	pass
func randomize_bg():
	pass

func end_combo(end_state):
	pass

func flash_and_disappear_combo():
	pass
	
func _process(delta):
	pass
