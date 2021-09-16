extends Area

var particles

func _ready():
	particles = get_parent().get_node("Particles")
	particles.emitting = true

func _physics_process(delta):
	
	for overlap in get_overlapping_bodies():
		if overlap.has_method("damage"):
			overlap.damage(1, Vector3.ZERO, global_transform.origin, global_transform.origin)
	if particles.emitting == false:
		queue_free()
		
