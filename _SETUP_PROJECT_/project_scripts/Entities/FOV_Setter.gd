extends Camera

var current_tick = 0
var prev_p
var current_p
var next_p

func _ready():
	set_process(true)


	
func _physics_process(delta):
	if far != Global.draw_distance:
		far = Global.draw_distance
	if fov != Global.FOV:
		pass
		

	

