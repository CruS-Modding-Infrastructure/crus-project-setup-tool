extends KinematicBody

export  var rotation_speed:float = 1

func _ready():
	rotation.y += rand_range(0, TAU)
func _physics_process(delta):
	
	rotation.y -= rotation_speed * delta
	
