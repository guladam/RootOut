extends Panel

onready var anim := $AnimationPlayer
onready var restart_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/Restart
onready var mainmenu_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/MainMenu
onready var buttons := $CenterCointainer/VBoxContainer/CenterContainer/Buttons


func fade_in() -> void:
	visible = true
	anim.play("FadeIn")
	restart_btn.grab_focus()


func _on_Pause_fadein_ended() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _on_MainMenu_pressed() -> void:
	# warning-ignore:return_value_discarded
	Config.restarting_level = false
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Restart_pressed() -> void:
	# warning-ignore:return_value_discarded
	Config.restarting_level = true
	get_tree().reload_current_scene()
