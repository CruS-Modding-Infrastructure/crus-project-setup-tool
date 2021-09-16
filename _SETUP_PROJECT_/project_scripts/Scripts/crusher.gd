extends KinematicBody

var t = 0
var a = 1
var mesh:MeshInstance
var glob

func _ready():
	glob = global_transform.origin
	for child in get_children():
		if child.get_class() == "MeshInstance":
			mesh = child
	a = mesh.get_aabb().size.y

func _physics_process(delta):
	t += delta * 3
	global_transform.origin.y = glob.y + sin(t / a) * 0.5 * a
