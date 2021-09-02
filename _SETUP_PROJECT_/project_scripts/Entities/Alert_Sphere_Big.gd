extends Area








func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.has_method("alert"):
		body.alert(global_transform.origin)



