extends AudioStreamPlayer3D








func _ready():
	pitch_scale += rand_range( - 0.2, 0.2)
	play()



func _process(delta):
	if not playing:
		queue_free()
