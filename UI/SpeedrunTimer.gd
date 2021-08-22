extends MarginContainer


onready var label = $MarginContainer/Label
var time_elapsed: float = 0

func _process(_delta: float) -> void:
	if Speedrun.running:
		label.text = Config.millisec_formatting(Speedrun.time_elapsed)
