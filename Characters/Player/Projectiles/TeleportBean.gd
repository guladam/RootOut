extends Area2D

signal teleport_bean_hit(pos)

var velocity: Vector2 = Vector2(350, 0)

func _ready() -> void:
	$AnimationPlayer.play("yeet")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()


func _on_TeleportBean_body_entered(_body: Node) -> void:
	emit_signal("teleport_bean_hit", global_position)
	queue_free()

