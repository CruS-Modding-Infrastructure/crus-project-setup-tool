extends PanelContainer





export  var in_game = false
var font:DynamicFont = preload("res://Fonts/mingliutsmall.tres")


func _ready():
	if in_game:
		rect_size = Vector2(640, 480)
		rect_scale = Vector2(Global.resolution[0] / 1280, Global.resolution[1] / 720)
		
		





func go():
	hide()
