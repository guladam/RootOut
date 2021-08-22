extends AudioStreamPlayer

var initial_volume

func _ready() -> void:
	initial_volume = volume_db
	set_volume()


func set_volume():
	volume_db = linear2db(db2linear(initial_volume) * Config.sfx_modifier)


func play_sound() -> void:
	if !playing and Config.sound_enabled:
		set_volume()
		play()


func play(from_position: float = 0.0) -> void:
	if Config.sound_enabled:
		set_volume()
		.play(from_position)
