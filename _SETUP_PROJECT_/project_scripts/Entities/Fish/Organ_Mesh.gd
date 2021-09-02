extends Spatial






var ORG = []

func _ready():
	for child in get_children():
		ORG.append(child)





func _process(delta):
	rotation.y += delta * 0.7
	rotation.z += delta * 0.6
