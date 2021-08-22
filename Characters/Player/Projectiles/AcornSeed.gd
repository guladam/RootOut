extends Area2D

var velocity: Vector2 = Vector2(350, 0)
var explosion_effect: PackedScene = preload("res://Effects/AcornExplosionEffect.tscn")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	rotation = velocity.angle()


func on_impact(damaged: bool, play_hit_sound: bool) -> void:
	var new_effect = explosion_effect.instance()
	Helper.get_scene_last_root().add_child(new_effect)
	new_effect.global_position = global_position
	if damaged and play_hit_sound:
		new_effect.get_node("HitSound").play_sound()
	else:
		new_effect.get_node("MissSound").play_sound()
	queue_free()


func _on_AcornSeed_body_entered(_body: Node) -> void:
	if _body.has_method("take_damage"):
		var invincible = false
		
		if _body.has_method("is_invincible"):
			invincible = _body.is_invincible()
		
		_body.take_damage()
		on_impact(true, _body.health > 0 and !invincible)
	else:
		on_impact(false, false)
