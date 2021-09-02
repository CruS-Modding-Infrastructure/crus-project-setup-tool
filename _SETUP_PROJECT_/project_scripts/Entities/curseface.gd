extends MeshInstance

var time = 0






func _ready():
	pass



func _process(delta):
	time += delta
	scale.x = sin(time) + 1.5
	scale.z = cos(time) * 0.5 + 1.1
