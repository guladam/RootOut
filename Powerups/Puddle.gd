extends Position2D

export(float) var healing_rate = 15

signal puddle_entered()
signal puddle_left()

onready var particles := $Particles2D

func _on_Area2D_body_entered(_area: Area2D) -> void:
	particles.emitting = true
	emit_signal("puddle_entered")


func _on_Area2D_body_exited(_area: Area2D) -> void:
	particles.emitting = false
	emit_signal("puddle_left")
