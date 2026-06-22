extends Node

var is_active : bool = true
var anim_frame_size : Vector2

func set_active(set_state = true):
	match set_state:
		true:
			$AnimatedSprite2D.set_animation("Beat")
			is_active = true
		false:
			$AnimatedSprite2D.set_animation("BeatGray")
			is_active = false

func get_anim_frame_size():
	var my_anim = $AnimatedSprite2D.sprite_frames.get_animation_names()[0]
	var my_frame = $AnimatedSprite2D.sprite_frames.get_frame_texture(my_anim , 0)
	anim_frame_size = my_frame.get_region().size
	return anim_frame_size

func play_anim():
	$AnimatedSprite2D.play()

func stop_anim():
	$AnimatedSprite2D.stop()
