extends Node





export  var scene = 5


func _ready():
	for child in get_children():
			child.body.set_physics_process(false)



func _physics_process(delta):
	if get_parent().current_scene == scene:
		for child in get_children():
			child.body.set_physics_process(true)
