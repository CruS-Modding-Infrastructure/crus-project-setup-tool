extends Area

func _ready():
	set_collision_layer_bit(9, 1)
	set_collision_layer_bit(0, 0)
	connect("body_entered", self, "_On_Body_Entered")

func _On_Body_Entered(body):
	if body.has_method("stop"):
		body.stop()
