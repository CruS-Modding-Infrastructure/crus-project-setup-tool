extends Position3D





var droplet = preload("res://droplet.tscn")
var droplets:Array

func _ready():
	
		queue_free()

func _physics_process(delta):
	if droplets.size() < 100:
		var new_droplet = droplet.instance()
		Global.player.get_parent().add_child(new_droplet)
		new_droplet.spawner = self
		new_droplet.global_transform.origin = global_transform.origin + Vector3(rand_range( - 10, 10), 0, rand_range( - 10, 10))
		droplets.append(new_droplet)



