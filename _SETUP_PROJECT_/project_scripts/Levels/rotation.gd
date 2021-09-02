extends MeshInstance

func _ready():
	pass
func _process(delta):
	rotation.y += 10 * delta
