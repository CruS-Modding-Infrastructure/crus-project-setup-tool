extends Spatial





var raindrop = preload("res://Entities/waterdrop.tscn")


func _ready():
	pass





func _process(delta):
	var new_raindrop = raindrop.instance()
	get_parent().get_parent().add_child(new_raindrop)
	new_raindrop.global_transform.origin = global_transform.origin + Vector3(rand_range( - 20, 20), 0, rand_range(20, 20))
