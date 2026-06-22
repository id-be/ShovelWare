extends Node2D

@export var ring_scene = preload("res://Scenes/MicroGames/MicroGameScriptsAndSubscenes/DeadRinger/DeadRingerRing.tscn")

func spawn_ring():
	await get_tree().create_timer(1.5).timeout
	var new_ring = ring_scene.instantiate()
	add_child(new_ring)
	new_ring.global_position.y=7
	new_ring.descend()

func increment_score():
	get_parent().increment_score()
