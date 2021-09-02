extends AudioStreamPlayer





export  var pitch_slide_speed = 0.01
var t = 0

func _ready():
	pass

func _physics_process(delta):
	pitch_scale += delta * pitch_slide_speed
	t += delta

	$MeshInstance.material_override.set_shader_param("a", AudioServer.get_bus_peak_volume_right_db(0, 0) * 0.001)
	$MeshInstance.material_override.set_shader_param("f", AudioServer.get_bus_peak_volume_left_db(0, 0) * 0.001)
	



