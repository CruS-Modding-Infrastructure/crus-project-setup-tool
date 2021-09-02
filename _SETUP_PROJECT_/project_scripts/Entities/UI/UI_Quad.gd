extends MeshInstance

func _ready():
	pass

func _physics_process(delta):

	scale.z = - Global.FOV * 0.01
	scale.x = - get_viewport().get_visible_rect().size.x / get_viewport().get_visible_rect().size.y
	transform.origin.z = - 2.3 + pow(Global.FOV, 2.55) * 1e-05
