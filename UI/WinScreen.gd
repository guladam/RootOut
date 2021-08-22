extends Panel

export(String) var next_level := "Level1"

onready var anim := $AnimationPlayer
onready var continue_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/Continue
onready var mainmenu_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/MainMenu
onready var buttons := $CenterCointainer/VBoxContainer/CenterContainer/Buttons

func fade_in() -> void:
	visible = true
	anim.play("FadeIn")
	continue_btn.grab_focus()


func _on_Pause_fadein_ended() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _on_MainMenu_pressed() -> void:
	# warning-ignore:return_value_discarded
	Config.restarting_level = false
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Continue_pressed() -> void:
	# warning-ignore:return_value_discarded
	Config.restarting_level = true
	get_tree().change_scene("res://Levels/" + next_level + ".tscn")
