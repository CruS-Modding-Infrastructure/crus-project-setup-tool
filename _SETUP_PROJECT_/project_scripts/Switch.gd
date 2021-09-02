extends Area

var button_audio
var error_audio
var overlap_exists = false

func _ready():
	set_collision_layer_bit(8, 1)
	button_audio = AudioStreamPlayer3D.new()
	add_child(button_audio)
	button_audio.global_transform.origin = global_transform.origin
	button_audio.unit_size = 5
	button_audio.unit_db = 2
	button_audio.pitch_scale = 0.7
	button_audio.stream = load("res://Sfx/Environment/Elevator_Bell.wav")
	error_audio = AudioStreamPlayer3D.new()
	add_child(error_audio)
	error_audio.global_transform.origin = global_transform.origin
	error_audio.unit_size = 5
	error_audio.unit_db = 2
	error_audio.stream = load("res://Sfx/UI/UI_selection.wav")

func use():
	overlap_exists = false
	var overlaps = get_overlapping_bodies()
	for overlap in overlaps:
		if overlap.has_method("use"):
			button_audio.play()
			overlap.use()
			overlap_exists = true
		if overlap.has_method("switch_use"):
			button_audio.play()
			overlap.switch_use()
			overlap_exists = true
	if not overlap_exists:
		error_audio.play()
	overlap_exists = false
