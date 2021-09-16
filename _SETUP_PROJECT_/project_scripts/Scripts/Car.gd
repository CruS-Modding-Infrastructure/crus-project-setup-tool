extends VehicleBody

export  var turn_amount = 0.3
var in_use = false
var init_player_basis
var last_rpm = 0
var time = 0
export  var engine = 2000

func _ready():
	set_collision_layer_bit(8, 1)

func _physics_process(delta):
	if in_use:
		Global.player.global_transform.origin = $Car / Player_Pos.global_transform.origin
	time += 1
	if not $VehicleWheel.is_in_contact():
		last_rpm = lerp(last_rpm, 2000, 0.1)
	else :
		last_rpm = abs($VehicleWheel.get_rpm())
	if in_use:
		if Input.is_action_pressed("movement_forward") or Input.is_action_pressed("movement_backward"):
			if fmod(time, 5) == 0 or not $SFX_Engine.playing:
				$SFX_Engine.pitch_scale = lerp($SFX_Engine.pitch_scale, last_rpm * 0.001 + 1, 0.2)
				$SFX_Engine.play()
		else :
			$SFX_Engine.pitch_scale = 1
		
		Global.player.weapon.left_arm_mesh.hide()
		Global.player.transform.basis = transform.basis * $Car / Player_Pos.transform.basis
		
		if Input.is_action_just_pressed("Use"):
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
		if not Input.is_action_pressed("movement_left") and not Input.is_action_pressed("movement_right"):
			steering = lerp(steering, 0, 0.5)

func use():
	sleeping = false
	if not in_use:
		init_player_basis = Global.player.transform.basis
		Global.player.crush_check.disabled = true
		Global.player.set_collision_mask_bit(7, false)
		yield (get_tree(), "idle_frame")
		in_use = true

func _input(event):
	if event is InputEventKey and in_use:
		if Input.is_action_pressed("movement_forward"):

			engine_force = engine
		elif Input.is_action_pressed("movement_backward"):
			if not $SFX_Engine.playing:
				$SFX_Engine.play()
			engine_force = - engine
		else :
			engine_force = 0
		if Input.is_action_pressed("movement_left"):
			steering = lerp(steering, turn_amount, 0.8)
		if Input.is_action_pressed("movement_right"):
			steering = lerp(steering, - turn_amount, 0.8)
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and in_use:
		
		$Car / Player_Pos.rotate_y(deg2rad(event.relative.x * Global.mouse_sensitivity * - 1))

func _on_VehicleBody_body_entered(body):
	if body.has_method("damage") and body != Global.player:
		body.damage(100, (global_transform.origin - body.global_transform.origin).normalized(), body.global_transform.origin, global_transform.origin)
	if body.has_method("physics_object"):
		body.queue_free()

func _on_Vehicle_body_entered(body):
	if body.has_method("physics_object"):
		body.queue_free()
