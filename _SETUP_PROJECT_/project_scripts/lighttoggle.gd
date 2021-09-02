extends OmniLight








func _ready():
	pass

func _physics_process(delta):
	if global_transform.origin.distance_to(Global.player.global_transform.origin) > 20:
		hide()
	else :
		show()



