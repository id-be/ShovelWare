extends Node2D;

var dragon = null;
var dragon_ahead_pos;

@export_range(20,500) var bolt_speed: int = 120;

func _process(delta) -> void:
	if dragon:
		if $HomingTimer.time_left > 0:
			$Bolt.global_position = $Bolt.global_position.move_toward(dragon_ahead_pos, bolt_speed * delta);
		else:
			$Bolt.global_position = $Bolt.global_position.move_toward(dragon.global_position, bolt_speed * delta);
	else:
		if $RayCast2D.is_colliding():
			dragon = $RayCast2D.get_collider();
			dragon_ahead_pos = dragon.global_position + Vector2(30, 0);
			$RayCast2D.enabled = false;
			$AnimatedSprite2D.play("shoot");
			$HomingTimer.start();


func _on_bolt_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Dragon":
		$Bolt.hide();
		area.get_parent().die();
