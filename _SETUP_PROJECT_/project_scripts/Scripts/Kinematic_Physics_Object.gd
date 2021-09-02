extends KinematicBody





var velocity = Vector3(0, 0, 0)
var gravity = 22
var held = false
var alerter = false
export  var grillable = false
var grill = false
var grill_health = 50
var grill_flag = false
var damager = false
export  var disabled = false
export  var usable = true
var alert_sphere = preload("res://Entities/Alert_Sphere_Big.tscn")
var blood_decal = preload("res://Entities/Decals/FleshDecal1.tscn")
export  var type = 1
export  var player_head = false
export  var particle = true
export  var mass = 1
export  var gun_rotation = false
export  var flesh = false
var angular_velocity = 0
export  var gas = false
var gas_cloud = preload("res://Entities/Bullets/Poison_Gas.tscn")
export  var collidable = false
export  var rotate_b = true
export  var shell = false
var grill_healing_item = preload("res://Entities/healing_item.tscn")
export  var stay_active = false
var impact_sound:Array
export  var sounds = false
var rot_changed = Vector3(0, 0, 0)
var t = 0
var water = false
var finished = false
var no_rot = false
var gun
var rot_towards
var rot_towards_z = 0
var rot_towards_x = 0
var rot_towards_y = 0
var new_alert_sphere
var particle_node
var sphere_collision
var distance
var glob
var first_col = true

func _ready():
	glob = Global
	set_process(false)
	if particle:
		particle_node = get_node_or_null("Particle")
	new_alert_sphere = alert_sphere.instance()
	add_child(new_alert_sphere)
	new_alert_sphere.global_transform.origin = global_transform.origin
	sphere_collision = new_alert_sphere.get_node("CollisionShape")
	sphere_collision.disabled = true
	gun = get_node_or_null("Area")
	set_collision_layer_bit(6, 1)
	set_collision_layer_bit(2, 0)
	set_collision_mask_bit(2, 1)
	set_collision_mask_bit(3, 1)
	rot_towards = global_transform.origin - velocity
	if not collidable:
		set_collision_layer_bit(0, 0)
	t += rand_range(0, 10)
	t = round(t)
	if sounds:
		impact_sound = [$Sound1]
		for sound in impact_sound:
			sound.pitch_scale -= mass * 0.1
	if gun_rotation:
		yield (get_tree(), "idle_frame")
		angular_velocity = Vector2(velocity.x, velocity.z).length()


func _physics_process(delta):
	if disabled:
		$CollisionShape.disabled = true
		set_physics_process(false)
		return 
	t += 1
	if Global.fps < 30 and not player_head:
		if global_transform.origin.distance_to(glob.player.global_transform.origin) > 20:
			return 
		
	
	if not stay_active and not gun_rotation or global_transform.origin.distance_to(glob.player.global_transform.origin) > 30:
		if fmod(t, 2) == 0:
			return 
		else :
			delta *= 2
	if grillable and grill:
		usable = false
		grill_health -= 1
	
	if grill_health <= 0 and not grill_flag:
		grill_flag = true
		$Gib.get_child(0).material_override = load("res://Materials/grilled.tres")
		var new_healing = grill_healing_item.instance()
		add_child(new_healing)
		new_healing.global_transform.origin = global_transform.origin
	
	
	if collidable:
		if Vector2(velocity.x, velocity.z).length() > 5:
			set_collision_layer_bit(0, 0)
			set_collision_mask_bit(2, 1)
			set_collision_mask_bit(3, 1)
		elif not held:
			set_collision_layer_bit(0, 1)
			set_collision_mask_bit(2, 0)
			set_collision_mask_bit(3, 0)
	if player_head:
		rot_towards = lerp(rot_towards, global_transform.origin - velocity, 5 * delta)
		if rot_towards.length() > 0.5:
			look_at(Vector3(rot_towards.x + 1e-06, global_transform.origin.y, rot_towards.z), Vector3.UP)
	if water:
		gravity = 2
	else :
		gravity = 22
	if finished:
		return 
	
	if gun_rotation:
		rotation.y += angular_velocity
	
	if not player_head and rotate_b:
		
		rotation.z = lerp(rotation.z, rot_towards_z, 0.5)
		rotation.x = lerp(rotation.x, rot_towards_x, 0.5)
	if Vector3(velocity.x, 0, velocity.z).length() > 0.4 and rotate_b:
		
		rot_towards_x -= velocity.length()
		
		
		
		
	elif not player_head and not no_rot and not gun_rotation and not gas:
		rotation = rot_changed
	
	var collision = move_and_collide(velocity * delta)

	if collision and alerter and velocity.length() > 7:
		sphere_collision.disabled = false
	elif sphere_collision.disabled == false:
		sphere_collision.disabled = true
		
	if collision and (t < 200 or stay_active):
		if velocity.length() > 5 and flesh and Global.fps > 30:
			var new_blood_decal = blood_decal.instance()
			collision.collider.add_child(new_blood_decal)
			new_blood_decal.global_transform.origin = collision.position
			new_blood_decal.transform.basis = align_up(new_blood_decal.transform.basis, collision.normal)
		if Vector2(velocity.x, velocity.z).length() > 5 and (gun_rotation or glob.implants.arm_implant.throw_bonus > 0):
			if collision.collider.has_method("damage"):
				damager = false
				collision.collider.damage(100, collision.normal, collision.position, global_transform.origin)
		elif sounds and abs(velocity.length()) > 2 and Global.fps > 30:
			var current_sound = 0
			impact_sound[current_sound].pitch_scale += rand_range( - 0.1, 0.1)
			impact_sound[current_sound].pitch_scale = clamp(impact_sound[current_sound].pitch_scale, 0.8, 1.2)
			impact_sound[current_sound].unit_db = velocity.length() * 0.1 - 1
			impact_sound[current_sound].play()
		if gas and velocity.length() > 4:
			var new_gas_cloud = gas_cloud.instance()
			get_parent().add_child(new_gas_cloud)
			new_gas_cloud.global_transform.origin = global_transform.origin
			queue_free()
		velocity = velocity.bounce(collision.normal) * 0.6
		
		angular_velocity = Vector2(velocity.x, velocity.z).length()
	if collision and t >= 200 and not player_head:
		if not stay_active:
			
			
			finished = true
		if particle:
			particle_node.emitting = false
			particle_node.hide()
	velocity.y -= gravity * delta

func align_up(node_basis, normal)->Basis:
	var result = Basis()
	var scale = node_basis.get_scale()

	result.x = normal.cross(node_basis.z) + Vector3(1e-05, 0, 0)
	result.y = normal + Vector3(0, 1e-05, 0)
	result.z = node_basis.x.cross(normal) + Vector3(0, 0, 1e-05)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z

	return result
func set_grill(value):
	if grillable:
		grill = value

func player_use():
	if not usable:
		return 
	if held == true:
		return 
	held = true
	if glob.implants.arm_implant.throw_bonus > 0:
		damager = true
	stay_active = true
	finished = false
	glob.player.weapon.hold(self)

func damage(damage, collision_n, collision_p, shooter_pos):
	if gas:
		var new_gas_cloud = gas_cloud.instance()
		get_parent().add_child(new_gas_cloud)
		new_gas_cloud.global_transform.origin = global_transform.origin
		queue_free()
	if damage < 3:
		return 
	randomize()
	velocity -= collision_n * damage / mass
	if not no_rot:
		look_at((global_transform.origin - collision_n * damage + Vector3(1e-05, 0, 0)), Vector3.UP)
		rot_changed = Vector3(0, rand_range( - PI, PI), rand_range( - PI, PI))
		rot_towards_y = rotation.y
	if gun_rotation:
		angular_velocity = velocity.length()
	
func set_water(a):
	water = a
	velocity *= 0.5
	velocity.y = 0

func get_type():
	return type;

func physics_object():
	pass
