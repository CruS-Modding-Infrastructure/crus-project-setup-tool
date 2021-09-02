extends StaticBody








func _ready():
	if Global.resolution[0] == 640:
		queue_free()



func _process(delta):
	if Global.resolution[0] == 640 or Global.implants.head_implant.holy:
		queue_free()
