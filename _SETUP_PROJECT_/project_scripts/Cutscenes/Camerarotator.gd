extends Spatial






export  var speed = 0.1

func _ready():
	pass


func _process(delta):
	rotation.y += delta * speed
