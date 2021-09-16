extends Area

func _ready():
	connect("body_entered", self, "_on_Body_entered")

func _on_Body_entered(body):
	if body.name == "Player" and $"/root/Global".objective_complete:
		Global.level_finished()
