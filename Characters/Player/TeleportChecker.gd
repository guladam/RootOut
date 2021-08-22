extends RayCast2D

signal teleport_succeeded(position)
signal teleport_failed()

onready var upwards := $TeleportUpwardsChecker

func check_if_succeeded(hit_position: Vector2) -> void:
	position = hit_position
	call_deferred("colliding")
	
	
func colliding() -> void:
	if is_colliding() and !upwards.is_colliding():
		emit_signal("teleport_succeeded", position)
	else:
		emit_signal("teleport_failed")
