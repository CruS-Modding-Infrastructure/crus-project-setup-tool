extends Spatial





var copcrew = preload("res://Entities/Props/copcrew.tscn")


func _ready():
	pass





func _physics_process(delta):
	if Global.objective_complete:
		var new_cop_crew = copcrew.instance()
		get_parent().add_child(new_cop_crew)
		new_cop_crew.global_transform.origin = global_transform.origin
		queue_free()
