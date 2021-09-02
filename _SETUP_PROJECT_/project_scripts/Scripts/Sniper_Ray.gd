extends RayCast








func _ready():
	pass

func _process(delta):
	look_at(Global.player.global_transform.origin + Vector3.UP * 1.2, Vector3.UP)
	if is_colliding():
		if get_collider() == Global.player:
			$MeshInstance.show()
		else :
			$MeshInstance.hide()
	else :
		$MeshInstance.hide()



