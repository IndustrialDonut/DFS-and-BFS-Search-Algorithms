extends Node2D


class InitiativeSorter:
	
	static func sort_ascending_initiative(a, b):
	
		return a.get_initiative() < b.get_initiative()
	

var queue = []


func _ready() -> void:
	
	randomize()
	
	queue = get_children()
	
	queue.sort_custom(InitiativeSorter, "sort_ascending_initiative")
	
	while not queue.empty():
		
		var node = queue.pop_front()
		
		print(node, " %d" % node.initiative)
