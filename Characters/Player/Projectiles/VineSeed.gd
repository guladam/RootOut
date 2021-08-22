extends Area2D

var vine: PackedScene = preload("res://Characters/Player/Projectiles/Vine.tscn")
var velocity: Vector2 = Vector2(350, 0)


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()


func _on_VineSeed_body_entered(_body: Node) -> void:
	var new_vine = vine.instance()
	Helper.get_scene_last_root().call_deferred("add_child", new_vine)
	new_vine.position = global_position
	queue_free()

