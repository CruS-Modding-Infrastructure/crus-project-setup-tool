extends ScrollContainer
var time = 0
const RANGE_LIMIT = 10
const MAGNIFICATION_FACTOR = 40
func _ready():
	pass
func _physics_process(delta):
	time += delta
	var audio_level = clamp(RANGE_LIMIT + AudioServer.get_bus_peak_volume_left_db(0, 0), 0.0, RANGE_LIMIT) / RANGE_LIMIT * MAGNIFICATION_FACTOR
	theme.get_stylebox("bg", "ScrollContainer").corner_radius_bottom_left = audio_level
	theme.get_stylebox("bg", "ScrollContainer").corner_radius_bottom_right = 0
	theme.get_stylebox("bg", "ScrollContainer").border_width_bottom = clamp(audio_level, 1, 5000)
