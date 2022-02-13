extends Node2D

class_name Astar
#https://www.youtube.com/watch?v=Z6QopKiRNLE
#This is last on the list so the debugging colors actually function

export (Color) var enabled_color
export (Color) var disabled_color
export (Color) var step_color
export (bool) var should_display_grid := true

onready var grid = $Grid
var grid_rects := {}

var astar = AStar2D.new()
var tilemap: TileMap
var half_cell_size: Vector2
var used_rect: Rect2



func create_navigation_map(newTilemap: TileMap):
	self.tilemap = newTilemap
	
	half_cell_size = newTilemap.cell_size / 2
	used_rect = newTilemap.get_used_rect()
	
	var tiles = newTilemap.get_used_cells()
	
	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	
	update_navigation_map_statics()


# Input is array of relative tile indicies
func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
		
		if should_display_grid:
			var rect := ColorRect.new()
			grid.add_child(rect)
			
			grid_rects[str(id)] = rect
			
			rect.modulate = Color(1, 1, 1, 0.5)
			rect.color = enabled_color
			
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			rect.rect_size = tilemap.cell_size
			rect.rect_position = tilemap.map_to_world(tile)


func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)

			
		#for x in range(2):
		#	for y in range(2):
		var neighbors = [Vector2(0,1), Vector2(-1,0), Vector2(1,0), Vector2(0,-1)]
		for point in neighbors:
			var target = tile + point
			var target_id = get_id_for_point(target)
			
			if tile == target or not astar.has_point(target_id):
				continue
			
			astar.connect_points(id, target_id, true)


func update_navigation_map_statics():
	# Turn off all points
	for point in astar.get_points():
		astar.set_point_disabled(point, true)
		if should_display_grid:
			grid_rects[str(point)].color = disabled_color
	
	var walls = get_tree().get_nodes_in_group("walkable")
	for walltile in walls:
		if walltile is TileMap:
			var tiles = walltile.get_used_cells()
			for tile in tiles:
				var id = get_id_for_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id, false)
					if should_display_grid:
						grid_rects[str(id)].color = enabled_color
	
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	for obstacletile in obstacles:
		if obstacletile is TileMap:
			var tiles = obstacletile.get_used_cells()
			for tile in tiles:
				var id = get_id_for_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id, true)
					if should_display_grid:
						grid_rects[str(id)].color = disabled_color


func update_navigation_map_dynamics(npc, enable=false):
	var obstacle = npc
	
	if obstacle is KinematicBody2D:
		var tile_coord = tilemap.world_to_map(obstacle.collision_shape.global_position)
		
		# All NPCs block out a 2x by 3y grid near their feet
		var id = get_id_for_point(tile_coord)
		var id1 = get_id_for_point(Vector2(tile_coord.x + 1, tile_coord.y))
		var id2 = get_id_for_point(Vector2(tile_coord.x - 1, tile_coord.y))
		var id3 = get_id_for_point(Vector2(tile_coord.x - 1, tile_coord.y - 1))
		var id4 = get_id_for_point(Vector2(tile_coord.x + 1, tile_coord.y - 1))
		var id5 = get_id_for_point(Vector2(tile_coord.x, tile_coord.y - 1))
		
		var ids = [id, id1, id2, id3, id4, id5]
		
		for cur_id in ids:
			if astar.has_point(cur_id):
				astar.set_point_disabled(cur_id, enable)
				if should_display_grid:
					if enable:
						grid_rects[str(cur_id)].color = enabled_color
					else:
						grid_rects[str(cur_id)].color = disabled_color
					
					if obstacle.get_node_or_null('TalkPosition'):
						var step_coord = tilemap.world_to_map(obstacle.get_node('TalkPosition').global_position)
						var stepId = get_id_for_point(step_coord)
						grid_rects[str(stepId)].color = step_color


func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	
	return x + y * used_rect.size.x


# Inputs are world coordinates!
func get_new_path(start: Vector2, end: Vector2) -> Array:
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	
	var start_id = get_id_for_point(start_tile)
	var end_id = get_id_for_point(end_tile)
	
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		print('Astar Error: No path found between tiles: ',start_id ,' and ', end_id)
		return []
	
	var path_map = astar.get_point_path(start_id, end_id)
	
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(Vector3(point_world.x, point_world.y, 0))
	
	return path_world

