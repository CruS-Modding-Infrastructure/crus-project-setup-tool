extends Spatial





var a = 0.01
var f = 0.05
var t = 0
var material


func _ready():
	if Global.soul_intact:
		queue_free()
	material = $MeshInstance.material_override
	
	
	
	



func _process(delta):
	t += 1
	rotation.y += 0.01
	global_transform.origin.y += sin(t * f) * a
	material.normal_scale = cos(t * 0.05) + 1
	material.emission_energy = sin(t * 0.05) * 0.5 + 1

