extends Area








func _ready():
	pass







func _on_Area_body_entered(body):
	if body.has_method("set_grill"):
		body.set_grill(true)


func _on_Area_body_exited(body):
	if body.has_method("set_grill"):
		body.set_grill(false)
