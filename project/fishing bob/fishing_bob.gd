extends RigidBody2D

@export var buoyancy_force_magnitude: float = 1000.0
var on_floatable_tile: bool = false


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if on_floatable_tile:
		await get_tree().create_timer(.5).timeout
		var buoyancy_force = Vector2(0, -buoyancy_force_magnitude)
		state.apply_central_force(buoyancy_force)
		print("floating!")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		var tile_map = body as TileMapLayer
		var tile_coords = tile_map.local_to_map(global_position)
		var tile_data = tile_map.get_cell_tile_data(tile_coords)
		
		if tile_data and tile_data.has_custom_data("is_water") and tile_data.get_custom_data("is_water"):
			on_floatable_tile = true
			print("water baby!!")
		else:
			on_floatable_tile = false
	else:
		on_floatable_tile = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		var tile_map = body as TileMapLayer
		var tile_coords = tile_map.local_to_map(global_position)
		var tile_data = tile_map.get_cell_tile_data(tile_coords)
		
		if tile_data and tile_data.has_custom_data("is_water") and tile_data.get_custom_data("is_water"):
			on_floatable_tile = false
			print("water no :(")
