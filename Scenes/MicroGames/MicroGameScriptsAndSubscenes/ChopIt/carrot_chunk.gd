extends Sprite2D

var t = 0.0
var target = false
var start_pos

@export var is_middle := false

func _physics_process(delta:float) -> void:
	if target:
		t += delta *2
		position = start_pos.lerp(target.position, t)

func chop():
	start_pos = position
	target = owner.get_node("Marker2D")
	pass
