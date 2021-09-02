extends KinematicBody

export  var turn_amount = 0.3
var in_use = false
var init_player_basis
var last_rpm = 0
var time = 0
var gravity = 22
var speed = 0
var rot_target = 0
export  var max_speed = 50
var velocity = Vector3.ZERO
var velocity_target = Vector3.ZERO
var up = Vector3.UP * 10
func _ready():

	set_collision_layer_bit(8, 1)



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

		
	var roty = rotation.y
	var n = Vector3.ZERO
	var c = 0
	var colliding = false
	for r in $RayCasts.get_children():
		if r.is_colliding():
			n += r.get_collision_normal()
			c += 1
			colliding = true
	if c != 0:
		n = n / c
	
	rotation.y = roty
	
	var u = transform.xform(up.normalized())
	print(u)
	
	transform.basis = align_up(transform.basis, up)
	
	if in_use:
		$SFX_Engine.pitch_scale = (abs(speed) + 0.01) * 0.1
		$SFX_Engine.play()

		if Input.is_action_pressed("movement_jump"):
			speed = lerp(speed, 0, delta * 5)
		if Input.is_action_pressed("movement_forward"):
			speed += 1
			speed = clamp(speed, - max_speed, max_speed)
		if Input.is_action_pressed("movement_backward"):
			speed -= 1
			speed = clamp(speed, - max_speed / 2, max_speed)
		

		speed = lerp(speed, 0, delta)
		
		
		velocity_target = (global_transform.origin - transform.xform(Vector3.DOWN)).normalized() * speed
		velocity = lerp(velocity, velocity_target, delta * 3)
		velocity_target = lerp(velocity_target, Vector3(0, velocity_target.y, 0), delta * 5)
		

		if Input.is_action_pressed("movement_left"):
			rot_target += speed * delta * 0.1
			
		elif Input.is_action_pressed("movement_right"):
			rot_target -= speed * delta * 0.1
			
		if abs(rotation.y - rot_target) >= PI * 2:
			rotation.y = rot_target
		rot_target = lerp(rot_target, 0, delta * 2)
		rotate_object_local(Vector3.UP, rot_target * delta * 3)
				
		Global.player.global_transform.origin = $Car / Player_Pos.global_transform.origin

	else :
		$SFX_Engine.stop()
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP, false, 4)
	up = lerp(up, Vector3(0, up.y, 0), delta * 0.5)

func _process(delta):
		if Input.is_action_just_pressed("Use") and in_use:
			$Car / Camera.current = false
			Global.player.transform.basis = init_player_basis * $Car / Player_Pos.transform.basis
			Global.player.player_velocity = Vector3.ZERO
			Global.player.set_collision_mask_bit(7, true)
			$CollisionShape.disabled = true
			Global.player.global_transform.origin = $ExitPos.global_transform.origin
			
			in_use = false
			
			yield (get_tree(), "idle_frame")
			$CollisionShape.disabled = false
			Global.player.crush_check.disabled = false
			Global.player.weapon.left_arm_mesh.show()
			Global.player.get_parent().show()
			Global.player.grab_hand.show()
			Global.player.show()
			Global.player.player_view.current = true
			Global.player.weapon.disabled = false
			Global.player.crush_check.disabled = false
			Global.player.disabled = false

func player_use():
	if not in_use:
		$Car / Camera.current = true
		init_player_basis = Global.player.transform.basis
		
		Global.player.get_parent().hide()
		Global.player.hide()
		Global.player.grab_hand.hide()
		Global.player.weapon.disabled = true
		Global.player.crush_check.disabled = true
		Global.player.disabled = true
		Global.player.set_collision_mask_bit(7, false)
		yield (get_tree(), "idle_frame")
		in_use = true

		
	


func _on_VehicleBody_body_entered(body):
	pass

func _on_Vehicle_body_entered(body):
	if body.has_method("physics_object"):
		body.queue_free()

func _input(event):
	if not in_use:
		return 
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if not Input.is_action_pressed("reload"):
			
			if abs(event.relative.x) > 1:
				up.x = lerp(up.x, event.relative.x * 0.1, 0.1)
			print(event.relative.x)
			if abs(event.relative.y) > 1:
				up.z = lerp(up.z, event.relative.y * 0.1, 0.1)
			
			
			
			
			
			
			

func _on_Area_body_entered(body):
	if velocity.length() < 15:
		return 
	if body.has_method("damage") and body != Global.player:
		body.damage(200, (global_transform.origin - body.global_transform.origin).normalized(), body.global_transform.origin, global_transform.origin)
	
		
