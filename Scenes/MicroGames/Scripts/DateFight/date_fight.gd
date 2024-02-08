extends microgame
#consider locking up the cursor after a choice for a lil
#sometimes the babe can turn into a monster and that's when you actually DO want to hit etc
#@onready var cursor = $Panel/Arrow
var cursor_location = 0

@export_range(2, 6) var num_actions = 2
@export_range(1, 5) var num_bad_actions = num_actions - 1

@export var choice_scripts : Array[Script]

var bad_actions = ["Punch", "Kick", "Hit", "Smack", "Blast", "Bash", "Shout", "Roman Tactics", "WWII History", "Mindmeld", "Fireball", "MagicMissl", "Blizanga", "Fireango", "Thundoblast", "ThoraxChew", "Suplex", "Poison", "ThrowGlass", "MakeScene", "UnwntdGift", "Phrenology", "Rob", "GlandChop", "Lick", "KarateChop", "JudoThrow", "SumoSlam", "EyeGouge", "Bore", "Snort", "NoseBlow", "NosePick", "JudoChop", "Uppercut", "KiBlast", "Brag"]
var good_actions = ["Smooch", "Kiss", "Hug", "Wink", "Flirt", "Poetry", "Compliment", "Gift", "Makeout"]
var neutral = "--"

var no_hl_text_bg = Color("715d00")
var hl_text_bg = Color("a40082")

#make 

# Called when the node enters the scene tree for the first time.
func _ready():
	boilerplate_ready()
#	$Cursor.toggle_self(false)
	generate_flirts()


func _set_difficulty(dif):
	match dif:
		"easy":
			num_actions = 2
			num_bad_actions = 1
		"medium":
			num_actions = 4
			num_bad_actions = 3
		"hard":
			num_actions = 6
			num_bad_actions = 5

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		pass
	elif Input.is_action_just_pressed("ui_left"):
		pass
	elif Input.is_action_just_pressed("ui_right"):
		pass
	elif Input.is_action_just_pressed("ui_down"):
		pass

#func hide_all_labels():
	#$Panel/Label.hide()
	#$Panel/Label2.hide()
	#$Panel/Label3.hide()
	#$Panel/Label4.hide()

func generate_flirts():
	#all we need to do here--randomly select which of 6 items will have the good thing, attach script
	#for child in $Panel/GridContainer.get_children():
	##	print(child.text)
		#child.set_script(choice_scripts[0])
#		pass
		#child.text = neutral

	var max_flirts = $Panel/GridContainer.get_child_count()
	var cur_good_act_index = 0
	var cur_bad_act_index = 0
	var my_actions = []
	my_actions.append("good_action")
	for num in num_bad_actions:
		my_actions.append("bad_action")
	for num in max_flirts-my_actions.size():
		my_actions.append("neutral_action")
	my_actions.shuffle()
	bad_actions.shuffle()
	good_actions.shuffle()
	#for act in my_actions:
		##$Panel/GridContainer.get_child(act)
		#print(act)
	for n in max_flirts:
		var cur_act = my_actions[n]
		var cur_label = $Panel/GridContainer.get_child(n)
		var cur_script
		match cur_act:
			"good_action":
				cur_act = good_actions[cur_good_act_index]
				cur_script = choice_scripts[0]
				cur_good_act_index += 1
			"bad_action":
				cur_act = bad_actions[cur_bad_act_index]
				cur_script = choice_scripts[1]
				cur_bad_act_index += 1
			"neutral_action":
				cur_act = neutral
				cur_script = choice_scripts[2]
		cur_label.text = cur_act
		cur_label.set_script(cur_script)
		#print($Panel/GridContainer.get_child(n))
		
	#var all_good_actions = 	good_actions.size()-1
	#var all_bad_actions = bad_actions.size()-1
	#
	#var my_good_action = good_actions[randi_range(0,good_actions.size()-1)]
	#for act in all_bad_actions:
		#pass
	
func make_choice(choice):
	match choice:
		"correct":
			update_hearts("up")
		"wrong":
			update_hearts("down")
		"false":
			Globals.set_and_play_sfx(_sfx[0])


func update_hearts(up_down):
	$Cursor.toggle_self(false)
	match up_down:
		"up":
			end_state = "success"
		"down":
			pass
