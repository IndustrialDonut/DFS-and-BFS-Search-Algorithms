extends Node2D

var ALLOW_DIAGS = true
var TARGET_FOUND = false

enum COL {BLACK, GREY, WHITE, TARGET, PATH}

var queue = []

var dict = {}

var path = []
var init_pos 

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("mouse_right"):
		
		var vec = get_global_mouse_position()
		
		$TileMap.set_cellv($TileMap.world_to_map(vec), COL.TARGET)
		
		#target_vec = $TileMap.world_to_map(vec)
		
		path.append($TileMap.world_to_map(vec))
		
		var inst = preload("res://Sprite.tscn").instance()
		add_child(inst)
		inst.global_position = vec
		inst.modulate = Color.red
	
	if Input.is_action_just_pressed("mouse_left"):
		
		var vec = get_global_mouse_position()
		
		
		queue.append($TileMap.world_to_map(vec))
		init_pos = $TileMap.world_to_map(vec)
		
		dict[$TileMap.world_to_map(vec)] = 0
		
		var inst = preload("res://Sprite.tscn").instance()
		add_child(inst)
		inst.global_position = vec
	
	if queue.size() and not TARGET_FOUND:
		
		var vec = queue.pop_front()
		var dist = dict[vec]
		
		
		for each in get_neighbors(vec):
			
			if $TileMap.get_cellv(each) == COL.TARGET:
				
				print("Target found")
				
				TARGET_FOUND = true
				
				queue.clear()
				
				break
			
			if $TileMap.get_cellv(each) == COL.WHITE:
				
				$TileMap.set_cellv(each, COL.GREY)
				
				queue.append(each)
				
				dict[each] = dist + 1
				
		$TileMap.set_cellv(vec, COL.BLACK)
	
	elif TARGET_FOUND:
		
		var vec = path[0]
		
		if vec == init_pos:
			
			return
		
		path.push_front(get_shortest_dist_neighbor(vec))
		
		$TileMap.set_cellv(path[0], COL.PATH)

func get_neighbors(coords):
	
	var neighbors = []
	
	for i in range(-1, 2):
		
		for j in range(-1, 2):
			
			if ALLOW_DIAGS:
				if i == 0 and j == 0: # allows diagonals
					continue
			else:
				if i and j:
					continue # do not allow diagonals
				
			neighbors.append(coords + Vector2(i, j))
			
	return neighbors


func get_shortest_dist_neighbor(coords):
	
	var neighbors = get_neighbors(coords)
	
	var shortest
	
	for neighbor in neighbors:
		
		if neighbor in dict:
			
			shortest = neighbor
	
	for neighbor in neighbors:
		
		if neighbor in dict:
		
			if dict[neighbor] < dict[shortest]:
				
				shortest = neighbor
		
	return shortest
