extends TextureProgress


func _on_PlayerHealth_changed(health: float) -> void:
	value = health
