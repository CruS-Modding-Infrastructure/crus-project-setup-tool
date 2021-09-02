extends Area

func _ready():

	
	connect("body_entered", self, "_on_Area_body_entered")
	connect("body_exited", self, "_on_Area_body_exited")
	connect("area_entered", self, "area_entered")
	set_collision_layer_bit(5, 1)
	set_collision_mask_bit(3, 1)
	set_collision_layer_bit(0, 0)
	set_collision_mask_bit(6, 1)
	set_collision_mask_bit(10, 1)
	yield (get_tree(), "idle_frame")
	if Global.hope_discarded:
		var toxic_mat = load("res://Maps/textures/swamp/swampwater1.tres")
		var meshes:Array
		for child in get_children():
			if child.get_class() == "MeshInstance":
				meshes.append(child)
		if meshes != null:
			for mesh in meshes:
				mesh.material_override = toxic_mat

func _on_Area_body_entered(body):
	if body.has_method("set_toxic") and Global.hope_discarded:
		body.set_toxic()
	if body.has_method("set_water"):
		body.set_water(true)

func _on_Area_body_exited(body):
	if body.has_method("set_water"):
		body.set_water(false)
func area_entered(area):
	if area.has_method("set_water"):
		area.set_water(true)
