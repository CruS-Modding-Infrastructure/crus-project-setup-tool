extends KinematicBody





var velocity = Vector3(0, - 100, 0)
var spawner
var framecounter = 0
var last_audio

func _ready():
	pass





func _physics_process(delta):
	return 
	framecounter += 1
	if framecounter < 20:
		return 
	var col = move_and_collide(velocity * delta)
	if col or global_transform.origin.y < Global.player.global_transform.origin.y - 10:
		if col:
			if is_instance_valid(last_audio):
				last_audio.queue_free()
			var new_audio = $AudioStreamPlayer3D.duplicate()
			spawner.add_child(new_audio)
			new_audio.play()
			last_audio = new_audio
		global_transform.origin = spawner.global_transform.origin + Vector3(rand_range( - 20, 20), 0, rand_range( - 20, 20))
