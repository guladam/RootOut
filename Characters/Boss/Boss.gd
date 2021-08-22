extends KinematicBody2D

signal boss_destroyed()

export(float) var rotation_seconds := 4
export(float) var radius := 125
export(int) var health := 3

onready var t := $Tween
onready var animation_player := $AnimationPlayer
onready var crystals := $Crystals.get_children()

var explosion_effect: PackedScene = preload("res://Effects/BossDeathEffect.tscn")
var remaining_crystals: int
var invincible: bool = true

func _ready() -> void:
	animation_player.play("Idle")
	remaining_crystals = len(crystals)
	
	var spacing = TAU / remaining_crystals
	
	for c in crystals:
		var crystal_node = c.get_child(0)
		var shift = spacing * c.get_position_in_parent() - PI / 2
		var dest = crystal_node.position + Vector2(radius, 0).rotated(shift)
		crystal_node.position = dest 

	tween_crystals()


func is_invincible() -> bool:
	return invincible


func take_damage() -> void:
	if invincible:
		return
	
	health -= 1
	
	if health == 2:
		var current_duration = animation_player.current_animation_position
		animation_player.current_animation = "IdleDamaged"
		animation_player.seek(current_duration)
		
	
	if health == 1:
		var current_duration = animation_player.current_animation_position
		animation_player.current_animation = "IdleHighlyDamaged"
		animation_player.seek(current_duration)
	
	if health == 0:
		visible = false
		var new_effect = explosion_effect.instance()
		Helper.get_scene_last_root().add_child(new_effect)
		new_effect.global_position = global_position
		new_effect.connect("tree_exited", self, "_on_effect_finished")
		new_effect.get_node("CrystalDeath").play_sound()


func _on_effect_finished():
	emit_signal("boss_destroyed")
	queue_free()


func _on_Crystal_crystal_destroyed() -> void:
	remaining_crystals -= 1
	if remaining_crystals == 0:
		invincible = false


func tween_crystals() -> void:
	if t.is_active():
		return
	
	for c in crystals:
		t.interpolate_property(c, "rotation_degrees", 0, 360, rotation_seconds, Tween.TRANS_LINEAR)
		t.start()


func _on_Tween_tween_all_completed() -> void:
	tween_crystals()
