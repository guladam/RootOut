extends VBoxContainer


onready var music := $MusicCheckButton
onready var sound := $SoundCheckButton

var toggle_enabled: bool = false

func _ready() -> void:
	music.pressed = Config.music_enabled
	sound.pressed = Config.sound_enabled
	toggle_enabled = true


func clear_focus() -> void:
	music.release_focus()
	sound.release_focus()


func _on_MusicCheckButton_toggled(button_pressed: bool) -> void:
	if !toggle_enabled:
		return
	
	Config.music_enabled = button_pressed
	MusicPlayer.set_music(button_pressed)


func _on_SoundCheckButton_toggled(button_pressed: bool) -> void:
	if !toggle_enabled:
		return
	
	Config.sound_enabled = button_pressed
