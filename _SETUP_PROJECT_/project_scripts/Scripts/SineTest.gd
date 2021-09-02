extends CanvasLayer

onready  var a = 1
onready  var b = 1
onready  var c = 1

func ready():
	update()

func _draw():
	for i in range(1000):
		draw_line(Vector2(a * i, b * sin(c * i)), Vector2(a * (i + 1), b * sin(c * (i + 1))), ColorN("slateblue"), 1)
