extends Area

func _ready():
	connect("body_entered", self, "_on_body_entered")
	set_collision_layer_bit(0, 0)
	set_collision_mask_bit(1, 1)

func _on_body_entered(body):
	if body != Global.player:
		return 
	var overlaps = get_overlapping_bodies()
	for overlap in overlaps:
		if overlap.has_method("destroy"):
			overlap.destroy(Vector3.DOWN, overlap.global_transform.origin)
