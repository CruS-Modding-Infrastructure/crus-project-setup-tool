extends PanelContainer
var time = 0
const RANGE_LIMIT = 10.0
const MAGNIFICATION_FACTOR = 50
func _ready():
	pass
func _physics_process(delta):
	time += delta
	var audio_level = clamp(RANGE_LIMIT + AudioServer.get_bus_peak_volume_left_db(0, 0), 0.0, RANGE_LIMIT) / RANGE_LIMIT * MAGNIFICATION_FACTOR

	
	
	
