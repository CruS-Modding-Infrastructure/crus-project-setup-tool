extends Spatial





export (Array, String) var entities



	
func _ready():
	var new_entity = load(entities[randi() % entities.size()]).instance()
	get_parent().call_deferred("add_child", new_entity)
	new_entity.global_transform.origin = global_transform.origin
	queue_free()





