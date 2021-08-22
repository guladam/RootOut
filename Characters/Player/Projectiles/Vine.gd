extends Area2D

signal vine_spawned(vine)

onready var anim = $AnimatedSprite

func _ready() -> void:
	anim.frame = 0
	anim.play("grow")
	
	# warning-ignore:return_value_discarded
	self.connect("vine_spawned", Helper.get_scene_last_root(), "on_Vine_spawned")
	
	emit_signal("vine_spawned", self)

