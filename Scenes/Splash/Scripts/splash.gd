extends Control

@export var ConchBlow = AudioStreamWAV

func _ready():
	Globals.sfx_player.stream = ConchBlow
	
	var tween = get_tree().create_tween()
	tween.tween_property($FG, "color", Color(1.0, 1.0, 1.0, 0.0), 1)
	await tween.finished
	$FG.color = Color(0.0, 0.0, 0.0, 0.0)
	
	Globals.sfx_player.play()
	tween = get_tree().create_tween()
	tween.tween_property($Underwriting, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
	await tween.finished
	
	var timer = get_tree().create_timer(2)
	await timer.timeout

	tween = get_tree().create_tween()
	tween.tween_property($FG, "color", Color(0.0, 0.0, 0.0, 1.0), 0.5)
	await tween.finished

	on_end_splash()


func on_end_splash():
	get_tree().change_scene_to_file("res://Scenes/Menu/MainMenu.tscn")
