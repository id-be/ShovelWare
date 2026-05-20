extends Node2D

func die():
	get_parent().get_parent().get_parent().speed=0
	$DragonAnimationPlayer.play("die")
	
	var sfx = get_parent().get_parent().get_parent().get_node("DragonSound")
	sfx.stream=load("res://Scenes/MicroGames/MicroGameAssets/DragonDrop/SFX/lordsonny-plasma-gun-fire-162136.mp3")
	sfx.pitch_scale = 4.0
	sfx.play()
