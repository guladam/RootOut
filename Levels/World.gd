extends Node2D

signal pause()
signal unpause()

export(bool) var first_level := true
export(bool) var last_level := false

onready var player := $Player
onready var player_hp := $Player/PlayerHealth
onready var teleport_checker := $TeleportChecker

onready var hp_bar = $HUD/HBoxContainer/Healthbar
onready var main_menu = $MenuLayer/MainMenu
onready var game_over = $MenuLayer/GameOverScreen
onready var win_screen = $MenuLayer/WinScreen
onready var end_screen = $MenuLayer/EndScreen
onready var story_screen = $MenuLayer/StoryScreen

onready var crystals: Array = get_tree().get_nodes_in_group("crystals")
onready var crystal_counter: int

var first_unpause: bool = true

func _ready() -> void:
	player_hp.connect("player_damaged", hp_bar, "_on_PlayerHealth_changed")
	player_hp.connect("player_healed", hp_bar, "_on_PlayerHealth_changed")
	teleport_checker.connect("teleport_succeeded", player, "_on_Teleport_succeeded")
	teleport_checker.connect("teleport_failed", player, "_on_Teleport_failed")
	
	var puddles = get_tree().get_nodes_in_group("puddle")
	for puddle in puddles:
		puddle.connect("puddle_entered", player_hp, "heal", [puddle.healing_rate])
		puddle.connect("puddle_left", player_hp, "stop_healing")
	
	crystal_counter = len(crystals)
	for crystal in crystals:
		crystal.connect("crystal_destroyed", self, "_on_Crystal_destroyed")
	
	if Config.restarting_level:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		main_menu.visible = false
		get_tree().paused = false
		main_menu.can_pause = true
		queue_back_music()
	else:
		get_tree().paused = true
		MusicPlayer.fade_to_menu()
		
	if Config.show_story:
		Config.show_story = false
		story_screen.fade_in()


func on_Vine_spawned(vine: Area2D) -> void:
	# warning-ignore-all:return_value_discarded
	vine.connect("body_entered", player, "start_climbing")
	vine.connect("body_exited", player, "end_climbing")


func on_TeleportBean_hit(pos: Vector2) -> void:
	teleport_checker.check_if_succeeded(pos)
	

func pause() -> void:
	get_tree().paused = true
	MusicPlayer.fade_to_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("pause")


func unpause() -> void:
	get_tree().paused = false
	queue_back_music()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("unpause")
	
	if first_level and first_unpause:
		Speedrun.reset_and_start()
		first_unpause = false


func _on_MainMenu_toggle_pause(paused) -> void:
	if paused:
		pause()
	else:
		unpause()


func queue_back_music():
	if name == "Level1":
		MusicPlayer.fade_to_game()
	elif name == "Level2":
		MusicPlayer.fade_to_level2()
	else:
		MusicPlayer.fade_to_boss()


func on_game_ended():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu.can_pause = false
	get_tree().paused = true


func _on_Crystal_destroyed():
	crystal_counter -= 1
	
	if crystal_counter <= 0:
		if !last_level:
			on_game_ended()
			win_screen.fade_in()


func _on_Boss_boss_destroyed() -> void:
	if last_level:
		on_game_ended()
		end_screen.fade_in()


func _on_Player_game_over() -> void:
	on_game_ended()
	game_over.fade_in()


func _on_Story_pressed() -> void:
	story_screen.fade_in()
