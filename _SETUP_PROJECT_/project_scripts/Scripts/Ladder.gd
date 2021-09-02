extends Area

func _ready():
	connect("body_entered", self, "_on_Area_body_entered")
	connect("body_exited", self, "_on_Area_body_exited")
	set_collision_layer_bit(0, 1)


func _on_Area_body_entered(body):
	if body.has_method("set_ladder"):
		body.set_ladder(true)

func _on_Area_body_exited(body):
	if body.has_method("set_ladder"):
		body.set_ladder(false)
