extends Panel

signal toggle_pause(paused)

onready var anim := $AnimationPlayer
onready var continue_btn := $MarginContainer/VBoxContainer/CenterContainer/Buttons/Continue
onready var newgame_btn := $MarginContainer/VBoxContainer/CenterContainer/Buttons/NewGame
onready var buttons := $MarginContainer/VBoxContainer/CenterContainer/Buttons
onready var sound_music_toggle := $MarginContainer/VBoxContainer/CenterContainer2/MusicSound/SoundAndMusicToggle
onready var sfx_slider := $MarginContainer/VBoxContainer/CenterContainer2/MusicSound/VBoxContainer/Center2/SoundSlider
onready var music_slider := $MarginContainer/VBoxContainer/CenterContainer2/MusicSound/VBoxContainer/Center/MusicSlider

var paused: bool
var can_pause: bool = false

func _ready() -> void:
	newgame_btn.grab_focus()
	paused =  !Config.restarting_level


func _input(event: InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		pause_toggle()


func release_all_focus():
	for b in buttons.get_children():
		b.release_focus()
	
	sound_music_toggle.clear_focus()
	sfx_slider.release_focus()
	music_slider.release_focus()


func pause_toggle():
	if anim.is_playing():
		return

	paused = !paused
	emit_signal("toggle_pause", paused)


func show_continue_btn() -> void:
	continue_btn.visible = true


func fade_in() -> void:
	show_continue_btn()
	anim.play("FadeIn")


func fade_out() -> void:
	anim.play("FadeOut")


func _on_NewGame_pressed() -> void:
	if !continue_btn.visible:
		pause_toggle()
		fade_out()
		MusicPlayer.fade_to_game()
	else:
		# warning-ignore:return_value_discarded
		Config.restarting_level = true
		Speedrun.reset_and_start()
		get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Continue_pressed() -> void:
	pause_toggle()
	fade_out()


func _on_World_pause() -> void:
	buttons.get_child(0).grab_focus()
	visible = true
	fade_in()


func _on_World_unpause() -> void:
	release_all_focus()
	mouse_filter = Control.MOUSE_FILTER_STOP
	fade_out()


func _on_ExitGame_pressed() -> void:
	get_tree().quit()


func _on_Pause_fadein_ended() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _on_Pause_fadeout_ended() -> void:
	visible = false
	can_pause = true
