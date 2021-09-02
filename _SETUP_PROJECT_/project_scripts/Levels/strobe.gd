extends OmniLight





var t = 0


func _ready():
	pass





func _physics_process(delta):
	if global_transform.origin.distance_to(Global.player.global_transform.origin) > 30:
		hide()
	else :
		show()
	t += 1
	if fmod(t, 6) != 0:
		light_negative = true
		light_energy = 5
		light_color = Color(1, 1, 1)
	else :
		light_negative = false
		light_color = Color(0, 1, 0)
		light_energy = 3 + sin(t * 0.01) * 3
