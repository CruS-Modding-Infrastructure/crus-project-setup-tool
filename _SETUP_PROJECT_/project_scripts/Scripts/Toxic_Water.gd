extends Area

func _ready():
	connect("body_entered", self, "_on_Area_body_entered")
	connect("body_exited", self, "_on_Area_body_exited")
	set_collision_layer_bit(5, 1)
	set_collision_mask_bit(3, 1)
	set_collision_layer_bit(0, 0)
	set_collision_mask_bit(6, 1)

func _on_Area_body_entered(body):
	if body.has_method("set_toxic"):
		body.set_toxic()
	if body.has_method("set_water"):
		body.set_water(true)

func _on_Area_body_exited(body):
	if body.has_method("set_water"):
		body.set_water(false)
