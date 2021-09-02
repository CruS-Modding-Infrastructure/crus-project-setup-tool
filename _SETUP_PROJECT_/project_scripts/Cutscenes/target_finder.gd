extends Area





var t = 0


func _ready():
	pass






func _physics_process(delta):
	t += 1
	if fmod(t, 200) == 0:
		for body in get_overlapping_bodies():
			get_parent().body.player = body
func _on_Area_body_entered(body):
	get_parent().body.player = body
