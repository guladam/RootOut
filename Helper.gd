extends Node


func get_scene_last_root():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count()-1)
