extends AudioStreamPlayer3D





var body


func _ready():
	body = get_parent()





func _physics_process(delta):
	if body.dead:
		queue_free()
