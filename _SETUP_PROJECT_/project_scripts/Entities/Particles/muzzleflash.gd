extends Spatial








func _ready():
	pass





func _physics_process(delta):
	if not visible:
		return 
	rotation.x = rand_range( - PI, PI)
