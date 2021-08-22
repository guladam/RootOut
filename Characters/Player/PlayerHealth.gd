extends Node

signal player_damaged(health)
signal player_healed(health)
signal player_died()

export(float) var drying_rate = 1
export(float) var low_hydration_threshold = 0.33
export(float) var max_health = 100
export(float) var health = 100

onready var heal_sfx := $HealingSound
onready var max_health_sfx := $MaxHealthSound
onready var low_hydration_sfx := $LowHydrationSound

var time_elapsed: float = 0
var healing_rate: float = 1
var invincible: bool = false
var healing: bool = false
var hydration_warning_played: bool = false


func heal(rate: float ) -> void:
	invincible = true
	healing = true
	healing_rate = rate
	heal_sfx.play_sound()


func stop_healing() -> void:
	invincible = false
	healing = false
	heal_sfx.stop()


func take_damage(damage: float) -> void:
	if not invincible and health >= 0:
		health -= damage
		emit_signal("player_damaged", health)
		
		if health / max_health <= low_hydration_threshold and !hydration_warning_played:
			low_hydration_sfx.play_sound()
			hydration_warning_played = true
		
		if health <= 0:
			emit_signal("player_died")


func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= 0.1:
		time_elapsed = 0
		take_damage(drying_rate / 10)
		
		if healing and health < max_health:
			health += healing_rate / 10
			emit_signal("player_healed", health)
			
			if health / max_health > low_hydration_threshold:
				hydration_warning_played = false
			
			if health >= max_health:
				heal_sfx.stop()
				max_health_sfx.play_sound()
