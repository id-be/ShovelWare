extends microgame

#really the irritability to make this more difficult would mean that
#the animal's angry state becomes longer while the normal state stays
#the same or becomes shorter
#potentially for a boss version: the irritability progressively gets longer the longer you wait until it becomes 100% and you lose.
#restart this on each pet, each successful pet adds a heart until you hit 3 and then it gets happy

#touch up the bottom of the jaws on the alligator

@export var bgs: Array[Texture] = []
@onready var bg = $TextureRect

@export var anims: Array[SpriteFrames] = []

var pet_start_state
var pet_state
var is_being_pet = false
var pet_change_state_time = 0.8
#can use the below to modulate the 
var pet_angry_time
var pet_normal_time

func _ready():
	boilerplate_ready()
	match pet_start_state:
		0:
			queue_pet_state("Angry")
		1:
			queue_pet_state("Normal")


func randomize_start_emotion():
	var start_state = randi_range(0,1)
	pet_start_state = start_state
	#match pet_start_state:
		#0:
			#Globals.set_and_play_music(_music_tracks[1])
		#1:
			#Globals.set_and_play_music(_music_tracks[0])
			
func randomize_background():
	var my_bg = randi_range(0, bgs.size()-1)
	var ran_orientation = false
	var ran_orientation_int = randi_range(0,1)
	bg.set_texture(bgs[my_bg])
	match ran_orientation:
		0:
			pass
			#ran_orientation = false
		1:
			ran_orientation = true
	bg.flip_h = ran_orientation
	
func _set_boss(boss):
	boilerplate_set_boss(boss)
	match is_boss:
		false:
			pass
		true:
			#refactor this into basemicrogame
			add_heart_handler()

func _set_difficulty(dif):
	match dif:
		"easy":
			$Animal.sprite_frames = anims[0]
			pet_change_state_time = 0.8
		"medium":
			$Animal.sprite_frames = anims[1]
			pet_change_state_time = 0.6
		"hard":
			$Animal.sprite_frames = anims[2]
			pet_change_state_time = 0.4

func _set_initial_values():
	randomize_background()
	randomize_hand_orientation()
	randomize_pet_orientation()
	randomize_start_emotion()

func _input(_event):
	if Input.is_action_just_pressed("button_1"):
		if !is_being_pet:
			is_being_pet = true
			end_anim_pet()

func randomize_hand_orientation():
	var hand_orientation = randi_range(0,1)
	match hand_orientation:
		0:
			pass
		1:
			$Hand.flip_h = true

func randomize_pet_orientation():
	var pet_orientation_h = randi_range(0,1)
	#var pet_orientation_v = randi_range(0,1)
	match pet_orientation_h:
		0:
			pass
		1:
			$Animal.flip_h = true
	#match pet_orientation_v:
		#0:
			#pass
		#1:
			#$Animal.flip_v = true

func _start():
	boilerplate_start()
	set_pet_state(pet_state)
	start_anims()

func queue_pet_state(state):
	pet_state = state

func set_pet_state(state):
	Globals.stop_sfx()
	match state:
		"Angry":
			Globals.set_and_play_music(_music_tracks[1])
			Globals.set_and_play_sfx(_sfx[0])
		"Normal":
			Globals.set_and_play_music(_music_tracks[0])
		"Happy":
			if !timer.is_stopped():
				timer.stop()
			if pet_state == "Angry":
				state = pet_state
				Globals.set_and_play_sfx(_sfx[1])
				end_state = "failure"
				$Animal.scale = $Animal.scale * 1.3
				if is_boss:
					end_state = "boss_failure"
					timer.start(2.0)
					await timer.timeout
					_end_game()
			else:
				if is_boss:
					heart_handler_instance.change_hearts_state()
					Globals.set_and_play_music(_music_tracks[2])
					if heart_handler_instance.is_done && is_being_pet:
						Globals.set_and_play_sfx(_sfx[2])
						end_state = "boss_success"
						pet_state = "Happy"
						$Animal.set_animation(pet_state)
						$Animal.play()
						timer.start(2.0)
						await timer.timeout
						_end_game()
						return
					state = "Normal"
					await Globals.music_player.finished
					reset_pet()
				else:
					Globals.set_and_play_music(_music_tracks[2])
					Globals.set_and_play_sfx(_sfx[2])
					end_state = "success"
	pet_state = state
	$Animal.set_animation(pet_state)
	$Animal.play()
func start_anims():
	$Hand/AnimationPlayer.play("Idle")
	animate_animal()

func animate_animal():
#try and stay away from these while loops :/
	while !is_being_pet:
		match pet_state:
			"Normal":
				set_pet_state("Angry")
			"Angry":
				set_pet_state("Normal")
		#above this you can set the pet_change_state_time in the pet_state state machine
		timer.start(pet_change_state_time)
		await timer.timeout
	
func end_anim_pet():
	if !timer.is_stopped():
		timer.stop()
	is_being_pet = true
	set_process_input(false)
	$Hand/AnimationPlayer.stop()
	$Hand/AnimationPlayer.seek(0)
	$Hand/AnimationPlayer.current_animation = "Pet"
	$Hand/AnimationPlayer.play()

	Globals.stop_music()
	set_pet_state("Happy")

func reset_pet():
	is_being_pet = false
	$Hand/AnimationPlayer.stop()
	$Hand/AnimationPlayer.seek(0)
	$Hand/AnimationPlayer.current_animation = "Idle"
	$Hand/AnimationPlayer.play()
	timer.start(pet_change_state_time)
	await timer.timeout
	set_process_input(true)
	#this hasn't been implemented correctly, the state doesn't always match the face
	var start_state = randi_range(0,1)
	pet_start_state = start_state
	match pet_start_state:
		0:
			queue_pet_state("Angry")
		1:
			queue_pet_state("Normal")

func _on_last_heart():
	pass
