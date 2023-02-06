extends Control


func _on_DFS_pressed() -> void:
	$Level.add_child(preload("res://DepthFirstSearchRevA.tscn").instance())


func _on_BFSMinPath_pressed() -> void:
	$Level.add_child(preload("res://BFSMinimumPath.tscn").instance())


func _on_Wavefront1_pressed() -> void:
	$Level.add_child(preload("res://Wavefront.tscn").instance())
