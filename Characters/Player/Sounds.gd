extends Node


onready var bean_hit := $BeanHit
onready var bean_fail := $BeanFail
onready var jump := $Jump
onready var walk := $Walk
onready var death := $Death


func play_bean_hit() -> void:
	bean_hit.play_sound()


func play_bean_fail() -> void:
	bean_fail.play_sound()


func play_jump() -> void:
	jump.play()


func play_death() -> void:
	death.play_sound()


func play_walk() -> void:
	walk.play_sound()


func stop_walk() -> void:
	walk.stop()
