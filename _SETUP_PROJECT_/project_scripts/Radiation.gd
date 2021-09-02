extends Particles





export  var damage = 0.4



func _physics_process(delta):
	
	for body in $Area.get_overlapping_bodies():
		if body == Global.player and Global.death:
			return 
		if body.has_method("damage"):
			body.damage(damage, Vector3.ZERO, body.global_transform.origin, global_transform.origin)



