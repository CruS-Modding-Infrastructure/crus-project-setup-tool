extends Spatial

export  var rotation_speed = 1

func _ready():
	rotation.y += rand_range(0, TAU)
func _process(delta):
	rotation.y -= rotation_speed * delta
	
