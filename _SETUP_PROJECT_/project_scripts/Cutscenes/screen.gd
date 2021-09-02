extends MeshInstance





export (Array, Resource) var images:Array = []
export  var cycle_speed = 1
export  var random = false
export  var sphere = false
var i = 0
var t = 0

func _ready():
	material_override.albedo_texture = images[0]
	if Global.high_performance:
		cycle_speed *= 0.5

func _physics_process(delta):
	t += 1
	if sphere:
		rotation.y = sin(t * 0.01) * 0.1
	if fmod(t, cycle_speed) != 0:
		return 
	i += 1
	i = wrapi(i, 0, images.size())
	if random:
		i = randi() % images.size()
		scale.x = rand_range(0.5, 1)
		scale.y = rand_range(0.5, 1)
	
	material_override.albedo_texture = images[i]



