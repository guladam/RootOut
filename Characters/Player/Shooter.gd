extends Position2D

export(float) var teleport_bean_hp_cost: float = 10
export(int) var acorn_muzzle_velocity: int = 300
export(int) var teleport_muzzle_velocity: int = 250
export(int) var gravity: int = 450

var can_shoot: bool = true
var can_teleport: bool = true
var teleport_finished: bool = true
var vine_seed: PackedScene = preload("res://Characters/Player/Projectiles/VineSeed.tscn")
var acorn_seed: PackedScene = preload("res://Characters/Player/Projectiles/AcornSeed.tscn")
var teleport_bean: PackedScene = preload("res://Characters/Player/Projectiles/TeleportBean.tscn")

onready var acorn_sfx := $AcornSoundEffect
onready var bean_sfx := $BeanSoundEffect
onready var bean_cd := $TeleportBeanCooldown
onready var acorn_cd := $AcornCooldown

func shoot_vine():
	var new_seed = vine_seed.instance()
	Helper.get_scene_last_root().add_child(new_seed)
	new_seed.global_rotation = get_parent().get_parent().global_rotation
	new_seed.global_position = to_global(position)
	new_seed.velocity = new_seed.transform.x * teleport_muzzle_velocity
	new_seed.gravity = gravity


func shoot_acorn():
	if !can_shoot:
		return
	
	var new_seed = acorn_seed.instance()
	Helper.get_scene_last_root().add_child(new_seed)
	new_seed.global_rotation = get_parent().get_parent().global_rotation
	new_seed.global_position = to_global(position)
	new_seed.velocity = new_seed.transform.x * acorn_muzzle_velocity
	new_seed.gravity = gravity
	acorn_sfx.play()
	
	acorn_cd.start()
	can_shoot = false


func shoot_teleport_bean():
	if !can_shoot_bean():
		return

	var root = Helper.get_scene_last_root()
	var new_seed = teleport_bean.instance()
	root.add_child(new_seed)
	new_seed.global_rotation = get_parent().get_parent().global_rotation
	new_seed.global_position = to_global(position)
	new_seed.velocity = new_seed.transform.x * teleport_muzzle_velocity
	new_seed.gravity = gravity
	new_seed.connect("teleport_bean_hit", root, "on_TeleportBean_hit")
	bean_sfx.play()
	
	can_teleport = false
	teleport_finished = false
	bean_cd.start()


func can_shoot_bean() -> bool:
	return can_teleport and teleport_finished


func set_teleport_finished(value: bool):
	teleport_finished = value


func _on_TeleportBeanCooldown_timeout() -> void:
	can_teleport = true


func _on_AcornCooldown_timeout() -> void:
	can_shoot = true
