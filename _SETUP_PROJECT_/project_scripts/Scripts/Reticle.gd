extends Control
var shot_reticle_radius = 5
var min_shot_reticle_radius = 5
var max_shot_reticle_radius = 30
var hit_reticle_radius = 0
var min_hit_reticle_radius = 0
var max_hit_reticle_radius = 50
var shooter_pos = Vector2.ZERO
var shooter_line_length = 0
var reticle_color = Color(1, 0, 0)
func _ready():
	max_shot_reticle_radius = get_viewport().size.y / 20
	max_hit_reticle_radius = get_viewport().size.y / 10

func hit():
	hit_reticle_radius = max_hit_reticle_radius
func shoot():
	shot_reticle_radius = max_shot_reticle_radius

func set_shooter_pos(shotpos):
		shooter_line_length = 50
		shooter_pos = Vector2(shotpos.x, shotpos.z)
func shot_line(v):
	var screen_center = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	draw_line(screen_center, screen_center + v * shooter_line_length, reticle_color)

func _physics_process(delta):
	if shooter_line_length > 0.05 or shot_reticle_radius > min_shot_reticle_radius + 0.05 or hit_reticle_radius > min_hit_reticle_radius + 0.05:
		update()
	shooter_line_length = lerp(shooter_line_length, 0, 0.2)
	shot_reticle_radius = lerp(shot_reticle_radius, min_shot_reticle_radius, 0.2)
	hit_reticle_radius = lerp(hit_reticle_radius, min_hit_reticle_radius, 0.2)

func _draw():
	draw_reticle()
	shot_line(shooter_pos)

func draw_reticle():
	var viewportsize = get_viewport().size
	draw_circle(Vector2(viewportsize.x / 2, viewportsize.y / 2), 2, reticle_color)
	draw_empty_circle(Vector2(viewportsize.x / 2, viewportsize.y / 2), Vector2(shot_reticle_radius, shot_reticle_radius), reticle_color, 7, false)
	draw_empty_circle(Vector2(viewportsize.x / 2, viewportsize.y / 2), Vector2(0, hit_reticle_radius), Color(0, 1, 0), 2, false)
	draw_empty_circle(Vector2(viewportsize.x / 2, viewportsize.y / 2), Vector2(hit_reticle_radius, 0), Color(0, 1, 0), 2, false)
	
	
		

func draw_empty_circle(circle_center, circle_radius, color, resolution, to_center):
	var draw_counter = 1
	var line_origin = Vector2()
	var line_end = Vector2()
	line_origin = circle_center + circle_radius

	for line in range(resolution):
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color)
		if to_center:
			draw_line(line_origin, get_viewport().size * 0.5, reticle_color)
		draw_counter += 360 / resolution
		line_origin = line_end
		line_end = circle_radius.rotated(deg2rad(resolution)) + circle_center
	line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
	draw_line(line_origin, line_end, color)
