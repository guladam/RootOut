extends Panel

onready var anim := $AnimationPlayer
onready var mainmenu_btn := $CenterCointainer/VBoxContainer/CenterContainer/Buttons/MainMenu


func fade_in() -> void:
	visible = true
	anim.play("FadeIn")
	mainmenu_btn.grab_focus()


func _on_Pause_fadein_ended() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS


func _on_MainMenu_pressed() -> void:
	anim.play("FadeOut")
