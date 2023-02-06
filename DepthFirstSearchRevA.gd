extends Node2D

var ALLOW_DIAGS = true
var TARGET_FOUND = false

enum COL {BLACK, GREY, WHITE, TARGET, PATH}

var stack = []

var cost_dict = {}
var predecessor_dict = {}

var path = []
var init_pos 
var target_pos


#func sort_vectors_by_cost(a, b):
	
#	return cost_dict[a] < cost_dict[b] # a comes first if smaller

func sort_vectors_by_target(a, b):
	
	var a_dist = a.distance_to(target_pos)
	var b_dist = b.distance_to(target_pos)
	
	return a_dist > b_dist # actually want it in DESCENDING order in stack


func _ready() -> void:
	
	for cell in $TileMap.get_used_cells():
		
		cost_dict[cell] = 9999.0

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("mouse_right"):
		
		var vec = get_global_mouse_position()
		
		$TileMap.set_cellv($TileMap.world_to_map(vec), COL.TARGET)
		
		target_pos = $TileMap.world_to_map(vec)
		
		path.append($TileMap.world_to_map(vec))
		
		var inst = preload("res://Sprite.tscn").instance()
		add_child(inst)
		inst.global_position = vec
		inst.modulate = Color.red
	
	if Input.is_action_just_pressed("mouse_left"):
		
		var vec = get_global_mouse_position()
		
		stack.append($TileMap.world_to_map(vec))
		init_pos = $TileMap.world_to_map(vec)
		
		cost_dict[$TileMap.world_to_map(vec)] = 0
		
		var inst = preload("res://Sprite.tscn").instance()
		add_child(inst)
		inst.global_position = vec
	
	if stack.size() and not TARGET_FOUND:
		
		var vec = stack.pop_back()
		
		for each in get_neighbors(vec):
			
			relax(vec, each)
			
		var list = get_neighbors(vec)
		
		list.sort_custom(self, "sort_vectors_by_target")
		
		#print(list)
		
		for each in list:
			
			if $TileMap.get_cellv(each) == COL.TARGET:
				
				TARGET_FOUND = true
				
				stack.clear()
				
				break
			
			if $TileMap.get_cellv(each) == COL.WHITE or $TileMap.get_cellv(each) == COL.GREY:
				
				$TileMap.set_cellv(each, COL.GREY)
				
				stack.append(each)
				
			$TileMap.set_cellv(vec, COL.BLACK)
	
	elif TARGET_FOUND:
		
		var vec = path.back()
		
		if vec == init_pos:
			
			return
		
		path.push_back(predecessor_dict[vec])
		
		$TileMap.set_cellv(path.back(), COL.PATH)

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
			
			if $TileMap.get_cellv(coords + Vector2(i, j)) != -1:
				
				neighbors.append(coords + Vector2(i, j))
			
	return neighbors


func relax(a, b):
	
	if cost_dict[a] + edge_weight(a, b) < cost_dict[b]:
		
		cost_dict[b] = cost_dict[a] + edge_weight(a, b)
		
		predecessor_dict[b] = a


func edge_weight(a : Vector2, b : Vector2):
	
	return a.distance_to(b)
