extends Area








func _ready():
	pass







func _on_Area_body_entered(body):
	if body.has_method("damage"):
		body.damage(100, (global_transform.origin - body.global_transform.origin).normalized(), body.global_transform.origin, global_transform.origin)
