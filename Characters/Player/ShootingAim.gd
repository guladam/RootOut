extends Node2D

export(float) var deadzone := 0.4

var controller_enabled: bool = false
var controller_id: int = 0
var rs_look: Vector2 = Vector2.ZERO


func _ready() -> void:
	# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	var controllers = Input.get_connected_joypads()
	if len(controllers) > 0:
		controller_id = controllers[0]
		controller_enabled = true


func _physics_process(_delta: float) -> void:
	if controller_enabled:
		rs_look.x = Input.get_joy_axis(controller_id, JOY_AXIS_2)
		rs_look.y = Input.get_joy_axis(controller_id, JOY_AXIS_3)
		if rs_look.length() >= deadzone:
			rotation = rs_look.angle()
	else:
		rotation = get_parent().get_local_mouse_position().angle()


func _on_joy_connection_changed(device_id: int, connected: bool) -> void:
	print("heh ", connected)
	controller_enabled = connected
	controller_id = device_id

