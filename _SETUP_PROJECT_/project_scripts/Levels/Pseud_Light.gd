extends Area

export  var light_color = Color(1, 0, 0)
export  var light_energy = 100
var global_light:DirectionalLight
var current_body
var light_on = false
var player

func _ready():
	global_light = get_parent().get_node("Global_Light")
	connect("body_entered", self, "_on_Body_entered")
	connect("body_exited", self, "_on_Body_exited")

func _physics_process(delta):
	if light_on:
		global_light.light_color = light_color / global_transform.origin.distance_to(player.global_transform.origin)
		global_light.light_energy = clamp(light_energy / global_transform.origin.distance_to(player.global_transform.origin), 0, 10)





func _on_Body_entered(body):
	player = body
	light_on = true

func _on_Body_exited(body):
	light_on = false
