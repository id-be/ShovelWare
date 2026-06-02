extends microgame

@export var taps := 0
var max_taps := 0
var animal_sound
var lerp_time = 0.01
var lerp_step = 0.1
var animal_target_pos = Vector2(10,33)
@onready var animal_sprite_start_pos = $AnimalSprite.position

func _ready():
	super()
	randomize_hatch_animal()

func _set_difficulty(dif) -> void:
	match dif:
		"easy":
			max_taps = 7
		"medium":
			max_taps = 10
		"hard":
			max_taps = 15
	taps = 0

func _on_button_pressed() -> void:
	taps += 1
	$AnimalSound.play()
	if taps < max_taps:
		var cur_fract = int(floor(float($BGSprite/CracksSprite.hframes-1)*float(taps)/float(max_taps)))
		$BGSprite/CracksSprite.frame = cur_fract
	else:
		$BGSprite/CracksSprite.frame = 4
		$Button.disabled = true
		end_state = "success"
		show_animal()

func randomize_hatch_animal() -> void:
	var animal = randi_range(0,2)
	match animal:
		0:
			$BGSprite/AnimalSprite.texture = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/Sprites/Dog.png")
			animal_target_pos = Vector2(10,33)
			animal_sound = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/SFX/bark.mp3")
		1:
			$BGSprite/AnimalSprite.texture = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/Sprites/bbduck-export.png")
			animal_target_pos = Vector2(10,36)
			animal_sound = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/SFX/chick_chirp.mp3")
		2:
			$BGSprite/AnimalSprite.texture = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/Sprites/Lizard.png")
			animal_target_pos = Vector2(10,33)
			animal_sound = load("res://Scenes/MicroGames/MicroGameAssets/HatchIt/SFX/lizard.mp3")
func show_animal() -> void:
	$BGSprite/EggHatchSprite.hide()
	#$BGSprite/AnimalSprite.position = animal_target_pos
	$BGSprite/CracksSprite.z_index -= 1
	#$BGSprite/AnimalSprite.position = animal_sprite_start_pos.lerp(animal_target_pos, 0)
	while $BGSprite/AnimalSprite.position > animal_target_pos:
		await get_tree().create_timer(lerp_time).timeout
		$BGSprite/AnimalSprite.position.y -= 5
	$AnimalSound.stream = animal_sound
	$AnimalSound.play()
