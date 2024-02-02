extends microgame

#@onready var cursor = $Panel/Arrow
var cursor_location = 0

@export_range(2, 6) var num_actions = 2
@export_range(1, 5) var num_bad_actions = 1

var bad_actions = ["Punch", "Kick", "Hit", "Smack", "Blast", "Bash", "Shout"]
var good_actions = ["Smooch", "Kiss", "Hug", "Wink", "Flirt"]
var neutral = "--"

var no_hl_text_bg = Color("715d00")
var hl_text_bg = Color("a40082")


# Called when the node enters the scene tree for the first time.
func _ready():
#	boilerplate_ready()
	generate_flirts()
	#hide_all_labels()
	pass # Replace with function body.

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
	for child in $Panel/GridContainer.get_children():
		pass
		#child.text = neutral
	var my_actions = []
	var all_good_actions = 	good_actions.size()-1
	var all_bad_actions = bad_actions.size()-1
	var my_good_action = good_actions[randi_range(0,good_actions.size()-1)]
	for act in all_bad_actions:
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
