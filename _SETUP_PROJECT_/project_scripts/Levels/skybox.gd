extends MeshInstance





export  var offset = 100


func _ready():
	pass



func _process(delta):
	global_transform.origin = Global.player.global_transform.origin + Vector3.UP * offset
