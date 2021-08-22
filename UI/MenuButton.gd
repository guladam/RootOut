extends NinePatchRect


signal clicked()


func highlight() -> void:
	modulate = Color("ccffff")


func end_highlight() -> void:
	modulate = Color("ffffff")


func _on_Button_focus_entered() -> void:
	highlight()


func _on_Button_focus_exited() -> void:
	end_highlight()


func _on_Button_mouse_entered() -> void:
	highlight()


func _on_Button_mouse_exited() -> void:
	end_highlight()


func _on_Button_pressed() -> void:
	emit_signal("clicked")
