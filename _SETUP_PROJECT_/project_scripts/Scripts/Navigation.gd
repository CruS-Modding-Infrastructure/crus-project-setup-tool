extends Navigation





var map:RID


func _ready():
	Global.nav = setup_navserver(Global.nav)
	var region = NavigationServer.region_create()
	NavigationServer.region_set_transform(region, get_parent().transform)
	NavigationServer.region_set_map(region, Global.nav)

	
	var navigation_mesh = NavigationMesh.new()
	navigation_mesh = $NavigationMeshInstance.navmesh
	NavigationServer.map_set_cell_size(Global.nav, navigation_mesh.cell_size)
	NavigationServer.region_set_navmesh(region, navigation_mesh)




func setup_navserver(gm):
	var i = 0
	if gm != null:
		for r in NavigationServer.map_get_regions(gm):
			NavigationServer.free_rid(r)
		NavigationServer.free_rid(gm)
	
	print(NavigationServer.get_maps().size())
	map = NavigationServer.map_create()
	NavigationServer.map_set_up(map, Vector3.UP)
	NavigationServer.map_set_active(map, true)
	return map

	
	
	yield (get_tree(), "physics_frame")
