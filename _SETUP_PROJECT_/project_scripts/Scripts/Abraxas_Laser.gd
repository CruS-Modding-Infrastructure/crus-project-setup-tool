extends KinematicBody

var type = 1
var laser
var health = 300
var follow_speed = 0.02
var particle
var active = false
var destroyed = false
var look_towards = Vector3.ZERO
var t = 0
var disabled = true

func _ready():
	look_towards = Global.player.global_transform.origin
	laser = $Laser
	particle = $Particles

func _process(delta):
	t += 1
	if destroyed:
		hide()
		return 
	if disabled:
		particle.hide()
		if laser.scale.z < 3:
			hide()
		laser.scale.z = lerp(laser.scale.z, 1, 0.2)
		return 
	show()
	look_towards = lerp(look_towards, Global.player.global_transform.origin, follow_speed)
	var space = get_world().direct_space_state
	if not active:
		var active_result = space.intersect_ray(global_transform.origin, Global.player.global_transform.origin + Vector3.UP * 0.5, [self])
		if active_result:
			if active_result.collider == Global.player:
				active = true
			else :
				return 
	var result = space.intersect_ray(global_transform.origin, global_transform.origin - (global_transform.origin - look_towards).normalized() * 200, [self])
	if result:
		particle.show()
		particle.global_transform.origin = result.position
		laser.scale.z = lerp(laser.scale.z, global_transform.origin.distance_to(result.position) * 0.5, 0.2)
		laser.look_at(result.position, Vector3.UP)
		if result.collider == Global.player:
			Global.player.damage(20, result.normal, result.position, global_transform.origin)		
	else :
		particle.hide()
		laser.scale.z = 400

func damage(dmg, nrml, pos, shoot_pos):
	if not active:
		return 
	health -= dmg
	if health <= 0:
		destroyed = true
		get_parent().get_node("Particle").show()
		get_parent().get_node("Sphere002").hide()

func get_type():
	return type;
