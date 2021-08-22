extends Node


onready var anim := $AnimationPlayer
onready var menu := $AudioStreamPlayerMenu
onready var game := $AudioStreamPlayerGame
onready var lvl2 := $AudioStreamPlayerLevel2
onready var boss := $AudioStreamPlayerBoss
onready var win := $AudioStreamPlayerEnd

var current: AudioStreamPlayer = null
var volumes = []

func _ready() -> void:
	volumes.append(menu.volume_db)
	volumes.append(game.volume_db)
	volumes.append(lvl2.volume_db)
	volumes.append(boss.volume_db)
	volumes.append(win.volume_db)


func get_volume(index: int) -> float:
	return linear2db(db2linear(volumes[index]) * Config.music_modifier)


func start_music() -> void:
	if !current:
		current = menu
		play_current()


func play_current() -> void:
	current.volume_db = get_volume(current.get_index())
	current.play()


func set_music(value) -> void:
	if value and current:
		play_current()
	elif current:
		current.stop()


func fade_to_menu() -> void:
	if !Config.music_enabled or current == menu:
		return

	current = menu
	anim.play("FadeToMenu")


func fade_to_game() -> void:
	if !Config.music_enabled or current == game:
		return

	current = game
	anim.play("FadeToGame")


func fade_to_level2() -> void:
	if !Config.music_enabled or current == lvl2:
		return

	current = lvl2
	anim.play("FadeToLevel2")


func fade_to_boss() -> void:
	if !Config.music_enabled or current == boss:
		return

	current = boss
	anim.play("FadeToBoss")


func fade_to_win() -> void:
	if !Config.music_enabled or current == win:
		return

	current = win
	anim.play("FadeToWin")


func volume_changed() -> void:
	var decibel = linear2db(Config.music_modifier)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), decibel)
