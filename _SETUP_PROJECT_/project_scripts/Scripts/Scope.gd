extends Control
var time = 0
func _ready():
	pass
func _physics_process(delta):
	if not visible:
		return 
	time += 1
	update()

func _draw():
	draw_line(Vector2((sin(time * 0.02) + 1 * 0.5) * get_viewport_rect().size.x, (cos(time * 0.02) + 1 * 0.5) * get_viewport_rect().size.y), Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2), Color(1, 0, 0))
	draw_line(Vector2((cos(time * 0.02) + 1 * 0.5) * get_viewport_rect().size.x, (sin(time * 0.02) + 1 * 0.5) * get_viewport_rect().size.y), Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2), Color(1, 0, 0))
	draw_line(Vector2(0, get_viewport_rect().size.y / 2), Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y / 2), Color(1, 0, 0))
