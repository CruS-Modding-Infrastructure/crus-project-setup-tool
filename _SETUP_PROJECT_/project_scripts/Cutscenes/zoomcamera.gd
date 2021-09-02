extends Camera





export  var init_fov = 70
export  var to_fov = 20
export  var zoom_speed = 0.01
export  var follow = false
var followed


func _ready():
	followed = get_parent().get_parent().get_node("Activator/Office_MG/Body")



func _process(delta):
	if current:
		if follow:
			look_at(followed.global_transform.origin, Vector3.UP)
		fov = lerp(fov, to_fov, zoom_speed)
