extends MeshInstance





export  var blood = true


func _ready():
	if blood:
		material_override.albedo_color = Global.blood_color
	var raycasts = [$RayCast, $RayCast2, $RayCast3, $RayCast4]
	yield (get_tree(), "idle_frame")
	for raycast in raycasts:
		raycast.force_raycast_update()
		if not raycast.is_colliding():
			queue_free()
		raycast.queue_free()
	if blood:
		show()
		return 
	scale.z = 0
	scale.x = 0
	show()
	
	while scale.x < 0.98:
		scale.x = lerp(scale.x, 1, 0.2)
		scale.z = lerp(scale.z, 1, 0.2)
		yield (get_tree(), "idle_frame")




