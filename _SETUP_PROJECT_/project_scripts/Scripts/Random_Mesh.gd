extends Spatial








func _ready():
	if randi() % 2 == 0:
		get_parent().queue_free()
	get_child(randi() % get_child_count()).show()





