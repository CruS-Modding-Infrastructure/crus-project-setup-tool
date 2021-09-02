extends KinematicBody





export  var speed = 50
export  var homing = false
var target
var head_entered = false
var target_found = false
var target_pos
var target_pos_prev
var time = 0
var velocity = Vector3(1, 1, 1)
onready  var explosion = preload("res://Entities/Bullets/Explosion.tscn")
onready  var BLOOD = preload("res://Entities/Particles/Blood_Particle3.tscn")


func _ready():
	
	pass



func _physics_process(delta):
	time += 1
	if speed > 15:
		speed *= 0.5
	if target != null and homing:
		target_pos = target.global_transform.origin + Vector3(0, 0.75, 0)
		target_pos_prev = lerp(target_pos_prev, target_pos, 0.1)
		look_at(target_pos_prev, Vector3.UP)
		rotate_object_local(Vector3(0, 1, 0), 3.14)

	if $Timer.is_stopped() and target != null and head_entered:
		var new_explosion = explosion.instance()
		get_parent().add_child(new_explosion)
		new_explosion.global_transform.origin = global_transform.origin - Vector3(0, 1, 0)
		$CollisionShape.disabled = true
		queue_free()
		
	var collision = move_and_collide(transform.basis.z * speed * delta)
	if collision:
		if collision.collider.has_method("damage") and collision.collider.get("alive_head") != null:
			if target != null:
				if collision.collider == target:
					head_entered = true
					if $Timer.is_stopped():
						$Timer.start(1)
						var new_blood = BLOOD.instance()
						target.add_child(new_blood)
						new_blood.global_transform.origin = collision.position
						new_blood.look_at(new_blood.global_transform.origin + collision.normal * 8, Vector3.UP)
						new_blood.emitting = true
				$MeshInstance.hide()
				$Blood_Particle2.hide()
		else :
			queue_free()
	
	
	
func set_velocity(new_velocity, direction):
	transform.basis = direction






























func _on_Area_body_entered(body):
	
	if body.get("alive_head") != null and not target_found:
		if body.alive_head == true:
			var space_state = get_world().direct_space_state
			var result = space_state.intersect_ray(global_transform.origin, body.global_transform.origin + Vector3(0, 0.75, 0))

			if result.collider == body:
				target_pos_prev = global_transform.origin
				target_pos = body.global_transform.origin + Vector3(0, 0.75, 0)
				target = body
				target_found = true
