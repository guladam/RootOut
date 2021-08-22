extends Node


var start_timer: float = 0
var time_elapsed: float = 0
var running = false

func reset_and_start():
	reset()
	start()


func reset():
	start_timer = OS.get_ticks_msec()


func start():
	running = true
	Speedrun.pause_mode = PAUSE_MODE_PROCESS
	

func stop() -> float:
	running = false
	return OS.get_ticks_msec() - start_timer


func _process(_delta: float) -> void:
	if running:
		time_elapsed = OS.get_ticks_msec() - start_timer
