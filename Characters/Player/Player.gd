extends KinematicBody2D

class_name Player

signal game_over()

export(int) var speed := 1200
export(int) var climb_speed := 400
export(int) var jump_speed := -550
export(int) var gravity := 4000
export(int) var climb_jump_velocity_x := 10

export(float) var climb_jump_modifier := 0.75
export(float, 0, 1.0) var friction := 0.1
export(float, 0, 1.0) var acceleration := 0.25
export(float, 0, 1.0) var climb_friction := 0.1
export(float, 0, 1.0) var climb_acceleration := 0.25

var dead: bool = false
var teleporting: bool = false
var stored_jump: bool = false
var climbing: bool = false
var jumping: bool = false
var was_on_floor: bool = false
var input_dir: float = 0
var velocity: Vector2 = Vector2.ZERO
var teleport_target: Vector2 = Vector2.ZERO

var dust: PackedScene = preload("res://Effects/DustParticle.tscn")

onready var climb_raycast := $ClimbRay
onready var jump_raycast := $GroundRay
onready var coyote_timer := $CoyoteTimer
onready var sprite := $Sprite
onready var animation_player := $AnimationPlayer
onready var sounds := $Sounds
onready var dust_spawn_point := $DustParticleSpawnPoint
onready var shooter := $ShootingAim/Aim/Shooter
onready var player_health := $PlayerHealth


func spawn_dust_particle() -> void:
	var new_dust = dust.instance()
	Helper.get_scene_last_root().add_child(new_dust)
	new_dust.global_position = to_global(dust_spawn_point.position)


func jump(modifier: float = 1) -> void:
	jumping = true
	velocity.y = jump_speed * modifier
	animation_player.play("jump")
	sounds.play_jump()
	sounds.stop_walk()
	spawn_dust_particle()


func should_jump() -> bool:
	return not climbing and not is_on_floor() and jump_raycast.is_colliding() and coyote_timer.time_left == 0


func animate_walking() -> void:
	animation_player.play("walk")


func start_climbing(_surface: Area2D) -> void:
	climbing = true


func end_climbing(_surface: Area2D) -> void:
	climbing = false


func get_input() -> int:
	var dir = 0
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		sprite.scale.x = sign(dir)
		if not jumping:
			sounds.play_walk()
			animate_walking()
	else:
		sounds.stop_walk()
		velocity.x = lerp(velocity.x, 0, friction)
		if not jumping:
			animation_player.play("idle")
			
	return dir


func get_climbing_input() -> void:
	var dir = 0
	if Input.is_action_pressed("climb_down"):
		dir += 1
	if Input.is_action_pressed("climb_up") and climb_raycast.is_colliding():
		dir -= 1
	if dir != 0:
		velocity.y = lerp(velocity.y, dir * climb_speed, climb_acceleration)
	else:
		velocity.y = lerp(velocity.y, 0, climb_friction)


func _physics_process(delta: float) -> void:
	if teleporting or dead:
		return

	was_on_floor = is_on_floor()
	input_dir = get_input()
	
	if not climbing:
		velocity.y += gravity * delta
	
	if climbing:
		velocity.y = 0
		velocity.x *= 0.6
		get_climbing_input()
	
	if not climbing:
		velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		jumping = false
		if not jumping and stored_jump:
			jump()
			stored_jump = false
	
	
	if Input.is_action_just_pressed("jump"):
		stored_jump = should_jump()
		
		if climbing and input_dir != 0:
			velocity.x = sign(input_dir) * climb_jump_velocity_x
				
			jump(climb_jump_modifier)
			climbing = false
		
		if not jumping and (is_on_floor() or coyote_timer.time_left > 0):
			jump()

	if was_on_floor and not is_on_floor():
		coyote_timer.start()
		
	if Input.is_action_just_pressed("fire1"):
		shooter.shoot_acorn()
	if Input.is_action_just_pressed("fire2"):
		if shooter.can_shoot_bean() and player_health.health >= shooter.teleport_bean_hp_cost:
			shooter.shoot_teleport_bean()


func _on_Teleport_succeeded(new_position: Vector2) -> void:
	sounds.play_bean_hit()
	teleporting = true
	teleport_target = new_position + Vector2(0, -10)
	animation_player.play("TeleportStart")
	player_health.take_damage(shooter.teleport_bean_hp_cost)


func _on_Teleport_failed() -> void:
	teleport_target = Vector2.ZERO
	sounds.play_bean_fail()
	shooter.set_teleport_finished(true)


func on_TeleportStart_animation_finished() -> void:
	position = teleport_target
	animation_player.play("TeleportEnd")
	
	
func on_TeleportEnd_animation_finished() -> void:
	teleporting = false
	teleport_target = Vector2.ZERO
	shooter.set_teleport_finished(true)


func _on_PlayerHealth_player_died() -> void:
	animation_player.play("Death")
	sounds.play_death()
	dead = true


func _on_Death_animation_finished() -> void:
	visible = false
	emit_signal("game_over")
