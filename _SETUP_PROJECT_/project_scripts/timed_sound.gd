extends Spatial





export  var first_scene = 0
export  var last_scene = 2
export  var play_once = false

func _ready():
	pass
func _physics_process(delta):
	if get_parent().current_scene >= first_scene and get_parent().current_scene <= last_scene:
		if not $AudioStreamPlayer3D.playing:
			show()
			$AudioStreamPlayer3D.play()
			if play_once:
				yield (get_tree().create_timer($AudioStreamPlayer3D.stream.get_length()), "timeout")
				queue_free()
	else :
		$AudioStreamPlayer3D.stop()
		hide()




