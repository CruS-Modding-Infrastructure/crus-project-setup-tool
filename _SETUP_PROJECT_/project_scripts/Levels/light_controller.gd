extends Spatial





var init_energy
var init_energy_ambient
var init_fog_color
var world:WorldEnvironment
var light:DirectionalLight
onready  var musicbus = AudioServer.get_bus_index("Music")

func _ready():
	world = $WorldEnvironment
	light = $Global_Light
	init_energy = light.light_energy
	init_energy_ambient = world.environment.ambient_light_energy
	init_fog_color = world.environment.fog_color
	

func _physics_process(delta):
	if Global.player.global_transform.origin.y < - 0.5:
		AudioServer.set_bus_volume_db(musicbus, lerp(AudioServer.get_bus_volume_db(musicbus), - 80, 0.05))
		light.light_energy = lerp(light.light_energy, 0, 0.2)
		world.environment.ambient_light_energy = lerp(world.environment.ambient_light_energy, 0, 0.2)
		world.environment.fog_color = lerp(world.environment.fog_color, Color(0, 0, 0), 0.2)
	else :
		AudioServer.set_bus_volume_db(musicbus, lerp(AudioServer.get_bus_volume_db(musicbus), Global.music_volume, 0.05))
		light.light_energy = lerp(light.light_energy, init_energy, 0.2)
		world.environment.ambient_light_energy = lerp(world.environment.ambient_light_energy, init_energy_ambient, 0.2)
		world.environment.fog_color = lerp(world.environment.fog_color, init_fog_color, 0.2)




