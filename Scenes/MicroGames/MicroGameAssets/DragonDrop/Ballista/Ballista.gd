extends Node2D

var dragon = null
var dragon_ahead_pos

@export_range(20,200) var bolt_speed: int = 120
#@export_range(-30, 30) var overcorrection: int = -40

func _physics_process(delta):
	if dragon:
		if $HomingTimer.time_left > 0:
			#var dragon_ahead_pos = dragon.global_position + Vector2(40, 0)
			$Bolt.global_position = $Bolt.global_position.move_toward(dragon_ahead_pos, bolt_speed * delta)
		else:
			$Bolt.global_position = $Bolt.global_position.move_toward(dragon.global_position, bolt_speed * delta)
	else:
		if $RayCast2D.is_colliding():
			#rotation_degrees = overcorrection
			dragon = $RayCast2D.get_collider()
			dragon_ahead_pos = dragon.global_position + Vector2(10, 0)
			$RayCast2D.enabled = false
			$AnimatedSprite2D.play("shoot")
			$HomingTimer.start()
