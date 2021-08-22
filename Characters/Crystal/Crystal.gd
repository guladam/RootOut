extends KinematicBody2D

signal crystal_destroyed()

export(int) var health := 2

var explosion_effect: PackedScene = preload("res://Effects/CrystalDeathEffect.tscn")
onready var animation_player := $AnimationPlayer


func _ready() -> void:
	animation_player.play("Idle")


func take_damage() -> void:
	health -= 1
	
	if health == 1:
		var current_duration = animation_player.current_animation_position
		animation_player.current_animation = "IdleDamaged"
		animation_player.seek(current_duration)
	
	if health == 0:
		visible = false
		var new_effect = explosion_effect.instance()
		Helper.get_scene_last_root().add_child(new_effect)
		new_effect.global_position = global_position
		new_effect.connect("tree_exited", self, "_on_effect_finished")
		new_effect.get_node("CrystalDeath").play_sound()


func _on_effect_finished():
	emit_signal("crystal_destroyed")
	queue_free()
