extends Panel

onready var anim := $AnimationPlayer

onready var mainmenu_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/MainMenu
onready var time := $CenterCointainer/VBoxContainer/HBoxContainer/Time
onready var best := $CenterCointainer/VBoxContainer/HBoxContainer/Best

func fade_in() -> void:
	MusicPlayer.fade_to_win()
	var current_time = Speedrun.stop()
	var highscore = "Best: 00:00:000"
	
	Config.load_highscore()
	
	if current_time < Config.high_score:
		Config.high_score = current_time
		Config.save_highscore(current_time)
	
	highscore = "Best: " + Config.millisec_formatting(Config.high_score)
		
	visible = true
	time.text = "Time: " + Config.millisec_formatting(current_time)
	best.text = highscore
	anim.play("FadeIn")
	mainmenu_btn.grab_focus()


func _on_Pause_fadein_ended() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _on_MainMenu_pressed() -> void:
	# warning-ignore:return_value_discarded
	Config.restarting_level = false
	get_tree().change_scene("res://Levels/Level1.tscn")
