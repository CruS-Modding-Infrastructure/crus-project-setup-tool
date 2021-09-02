extends Position3D
var time = 1
var intro_music = preload("res://Sfx/Music/intro.ogg")
func _ready():
	Global.screenmat.set_shader_param("hit_red", 0)
	Global.screenmat.set_shader_param("health_green", 0)
	Global.screenmat.set_shader_param("water", false)
	Global.screenmat.set_shader_param("holy_mode", false)
	Global.screenmat.set_shader_param("nightmare_vision", false)
	Global.screenmat.set_shader_param("scope", false)
	Global.music.stream = intro_music
	Global.music.play()

func _process(delta):
	time += delta
	rotation.y = sin(time * 0.2)
	$Camera.fov = 75 + sin(time * 0.4) * 35
	$Camera / Position3D / MeshInstance / OmniLight3.light_energy = sin(time * 2) * 2
	$Camera / Position3D / MeshInstance.transform.origin.y = 0 + sin(time * 0.4) * 0.8
	
