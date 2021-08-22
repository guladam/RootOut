extends Path2D


export(int) var patrol_speed := 120
onready var follow := $PathFollow2D


func _physics_process(delta: float) -> void:
	follow.unit_offset += patrol_speed / 1000.0 * delta
