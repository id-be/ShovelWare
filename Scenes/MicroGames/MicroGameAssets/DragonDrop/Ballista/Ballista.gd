extends Node2D

var dragon = null

func _physics_process(delta):
	if dragon:
		$Bolt.position = $Bolt.position.move_toward(dragon.position)
	else:
		if $RayCast2D.is_colliding():
			dragon = $RayCast2D.get_collider()
			$RayCast2D.enabled = false
			$AnimatedSprite2D.play("shoot")
