extends HBoxContainer


func _ready() -> void:
	$VBoxContainer/Center/MusicSlider.value = 100
	$VBoxContainer/Center2/SoundSlider.value = 100
	

func _on_MusicSlider_value_changed(value: float) -> void:
	Config.music_modifier = value / 100
	MusicPlayer.volume_changed()


func _on_SoundSlider_value_changed(value: float) -> void:
	Config.sfx_modifier = value / 100
