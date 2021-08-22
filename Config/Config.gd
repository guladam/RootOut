extends Node

var sound_enabled: bool = true
var music_enabled: bool = true
var restarting_level: bool = false
var show_story: bool = true

var sfx_modifier: float = 1
var music_modifier: float = 1

var save_file = "user://progress.save"
var high_score: float = INF

func millisec_formatting(t: float) -> String:
	var minutes = int(t / 60 / 1000)
	var seconds = int(t / 1000) % 60
	var miliseconds = int(t) % 1000

	return ("%02d" % minutes) + (":%02d" % seconds) + (":%03d" % miliseconds)


func save_highscore(highscore):
	var file = File.new()
	file.open(save_file, File.WRITE)
	file.store_var(highscore)
	file.close()


func load_highscore():
	var file = File.new()
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		high_score = file.get_var()
		file.close()
	else:
		high_score = INF
