extends Camera





var flares:Array
var t = 0
var active = false

func _ready():
	hide()
	$Flare.global_transform.origin = (global_transform.origin - $Sun.global_transform.origin).normalized() * 50
	for i in range(20):
		var new_flare = $Flare.duplicate()
		add_child(new_flare)
		new_flare.global_transform.origin = (global_transform.origin - $Sun.global_transform.origin).normalized() * i
		flares.append(new_flare)
	
	active = false


func _process(delta):
	if not active:
		var space = get_world().direct_space_state
		var result = space.intersect_ray($Sun.global_transform.origin, global_transform.origin)
		if not result:
			active = true
	if not active:
		return 
	show()
	t += 1
	$Sun.transform.origin.x += sin(t * 0.01) * 0.01
	$Sun.transform.origin.y += sin(t * 0.01) * 0.01
	$Flare.global_transform.origin = global_transform.origin - (global_transform.origin - $Sun.global_transform.origin).normalized() * 10
	var i = 0
	for flare in flares:
		i += 1
		flare.scale.x = sin(i)
		flare.rotation.z = sin(i + t * 0.01)
		flare.scale.y = sin(i)
		flare.global_transform.origin = global_transform.origin - (global_transform.origin - $Sun.global_transform.origin).normalized() * i
		flare.global_transform.origin.x += sin((t + i) * 0.01) * 0.1
		flare.global_transform.origin.x += cos((t + i) * 0.01) * 0.1
