extends KinematicBody





export  var speed = 10
export  var homing = false
export  var piercing = false
var target
var target_pos
var collisions = 0
var target_pos_prev
var time = 0
var velocity = Vector3(0, 0, 0)
var explosion = preload("res://Entities/Bullets/Explosion.tscn")
var shrapnel = preload("res://Entities/Bullets/Explosive_Grenade_Impact.tscn")
var decal = preload("res://Entities/Decals/BigHole.tscn")


	
	
	

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

func _physics_process(delta):
	if piercing:
		$MeshInstance.scale = lerp($MeshInstance.scale, Vector3.ONE, 0.8)
	time += 1
	if speed < 25:
		speed *= 1.2
	if target != null and homing:
		target_pos = target.global_transform.origin + Vector3(0, 0.75, 0)
		target_pos_prev = lerp(target_pos_prev, target_pos, 0.1)
		look_at(target_pos_prev, Vector3.UP)
		rotate_object_local(Vector3(0, 1, 0), 3.14 + sin(time * 0.01) * 1.5)
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		if not piercing:
			var smokeparticle = $Smoke_Particle
			remove_child(smokeparticle)
			get_parent().add_child(smokeparticle)
			smokeparticle.emitting = false
			smokeparticle.get_node("OmniLight").queue_free()
			var new_explosion = explosion.instance()
			collision.collider.get_parent().add_child(new_explosion)
			new_explosion.global_transform.origin = global_transform.origin - Vector3(0, 1, 0)
			$CollisionShape.disabled = true
			var shrapnel_rotation = Vector3(1, 1, 0).rotated(Vector3.UP, deg2rad(rand_range(0, 180)))
			for i in range(4):
				shrapnel_rotation = shrapnel_rotation.rotated(Vector3.UP, deg2rad(90))
				var new_shrapnel = shrapnel.instance()
				get_parent().add_child(new_shrapnel)
				new_shrapnel.shrapnel_flag = true
				new_shrapnel.global_transform.origin = global_transform.origin + Vector3.UP
				new_shrapnel.set_velocity(rand_range(10, 30), (new_shrapnel.global_transform.origin - (new_shrapnel.global_transform.origin - shrapnel_rotation)).normalized(), global_transform.origin)
			queue_free()
		else :
			collisions += 1
			if collisions > 10:
				queue_free()
			if collision.collider.has_method("piercing_damage"):
				collision.collider.piercing_damage(150, (global_transform.origin - collision.position).normalized(), global_transform.origin, global_transform.origin)
			if collision.collider.has_method("damage"):

				collision.collider.damage(150, (global_transform.origin - collision.position).normalized(), global_transform.origin, global_transform.origin)
			else :
				decal(collision.collider, collision.position, collision.normal)
				queue_free()
	
	
	
func set_velocity(new_velocity, direction):
	transform.basis = direction

func decal(collider:Spatial, c_point, c_normal)->void :
	if not is_instance_valid(collider):
		return 
	if collider.get_collision_layer_bit(0) == true:
		var decal_new = decal.instance()
		collider.add_child(decal_new)
		decal_new.global_transform.basis = align_up(decal_new.global_transform.basis, c_normal)
		decal_new.global_transform.origin = c_point + c_normal * 1e-08




























func _on_Area_body_entered(body):
	if body.get("alive_head") != null and target == null:
		if body.alive_head == true:
			target_pos_prev = body.global_transform.origin + Vector3(0, 0.75, 0)
			target_pos = body.global_transform.origin + Vector3(0, 0.75, 0)
			target = body
			


