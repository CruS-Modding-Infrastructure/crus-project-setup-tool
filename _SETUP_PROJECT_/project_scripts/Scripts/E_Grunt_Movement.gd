extends KinematicBody

var rotation_helper
var player_ray
var velocity_ray
var in_sight
var in_view = false
var weapon
var rotate_towards = 0
var anim_player
var anim_tree
const DEATH_ANIMS = ["Death1", "Death2"]

var player
var player_last_seen
var last_seen_n
var time = 0
var dead = false

export  var gravity = 22
export  var friction = 6

export  var move_speed = 4.5
export  var run_acceleration = 100
export  var run_deacceleration = 10
export  var air_acceleration = 2
export  var air_deacceleration = 20
export  var air_control = 2
export  var side_strafe_acceleration = 0.06
export  var side_strafe_speed = 0.06
export  var jump_speed = 7
var hold_jump_to_bhop = false

var move_direction = Vector3(0, 0, 0)
var move_direction_norm = Vector3(0, 0, 0)
var enemy_velocity = Vector3(0, 0, 0)
var enemy_top_velocity = 0

var wish_jump = false
var flee = false

var enemy_friction = 0

class Cmd:
	var forward_move:float
	var right_move:float
	var up_move:float
var initrotx
var cmd

onready  var soul = get_parent()

func _ready():
	randomize()
	time = round(rand_range(1, 100))
	
	initrotx = rotation.x
	player = get_node("../../Player")
	player_ray = $Player_Ray
	velocity_ray = $Velocity_Ray
	
	last_seen_n = Vector3.ZERO
	in_sight = false
	weapon = $Rotation_Helper / Weapon
	rotation_helper = $Rotation_Helper
	cmd = Cmd.new()
	anim_player = get_parent().get_node("Nemesis/AnimationPlayer")

func _physics_process(delta):
	if global_transform.origin.distance_to(player.global_transform.origin) < 30:
		time += 1
		if player != null:
			player_ray.force_raycast_update()
			player_ray.look_at(player.global_transform.origin + Vector3(0, 1, 0), Vector3.UP)
		if player_ray.get_collider():
			player_ray.force_raycast_update()
			if player_ray.get_collider() == player:
				soul.set_player_seen(true)
				if player_last_seen != null:
					player_last_seen = lerp(player_last_seen, player.global_transform.origin, 0.1)
			else :
				soul.set_player_seen(false)
		
		if is_on_floor():
			ground_move(delta)
			if dead == false:
				anim_player.playback_speed = 2
				if cmd.right_move == 0 and cmd.forward_move == 0:
					anim_player.play("Idle")
				if cmd.forward_move == - 1 and cmd.right_move == 0:
						anim_player.play("Run")
				if cmd.right_move == 1:
					anim_player.play("Run_Right")
				if cmd.right_move == - 1:
					anim_player.play("Run_Left")
		elif not is_on_floor():
			air_move(delta)
			if dead == false and not is_on_wall():
				anim_player.play("Jump")
		
		enemy_velocity.y -= gravity * delta
		move_and_slide(enemy_velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(45))
		
		var udp = enemy_velocity
		udp.y = 0.0
		if udp.length() > enemy_top_velocity:
			enemy_top_velocity = udp.length()

func set_animation(anim, speed):
	anim_player.play(anim)
	anim_player.playback_speed = speed

func behaviour(delta):
	if dead == false:
		velocity_ray.cast_to = Vector3(cmd.right_move, 0, cmd.forward_move)
		if not flee:
			look()
			if (global_transform.origin.distance_to(player.global_transform.origin) > 15 or player_ray.get_collider() != player) and player_last_seen != null:
					cmd.forward_move = - 1
			else :
				cmd.forward_move = 0
			if player_ray.get_collider() == player and in_view:
				if $Reaction_Timer.is_stopped() and $Shoot_Timer.is_stopped():
					$Reaction_Timer.start(1)
					$Shoot_Timer.start(0.5)
				if $Shoot_Timer.is_stopped() and player.health > - 200:
					weapon.AI_shoot()
				if not in_sight:
					cmd.right_move = round(rand_range( - 1, 1))
					in_sight = true
				if velocity_ray.is_colliding():
					velocity_ray.cast_to = Vector3(0, 0, 0)
					
					cmd.right_move = 0
					cmd.forward_move = 0
				if fmod(time, 300) == 0:
					cmd.right_move = round(rand_range( - 1, 1))
			else :
				cmd.right_move = 0
				in_sight = false
				if $Chase_Timer.is_stopped() and player_last_seen != null:
					patrol()
				elif player_last_seen == null:
					if fmod(time, 20) == 0:
						rotate_towards = round(rand_range( - PI, PI))
					rotation.y = lerp(rotation.y, rotate_towards, 0.2)
		else :
			weapon.AI_shoot()
			patrol()
	else :
		cmd.right_move = 0
		cmd.forward_move = 0

func patrol():
	cmd.right_move = 0
	cmd.forward_move = - 1
	if fmod(time, 100) == 0:
		rotate_towards = round(rand_range( - PI, PI))
	if velocity_ray.is_colliding():
		rotate_towards = round(rand_range( - PI, PI))
	rotation.y = lerp(rotation.y, rotate_towards, 0.2)

func queue_jump():
	
	if hold_jump_to_bhop:
		wish_jump = Input.is_action_pressed("movement_jump")
		return 
	if fmod(time, 200) == 0 and not wish_jump:
		wish_jump = true
	
	

func air_move(delta):
	var wishdir
	var wishvel = air_acceleration
	var accel
	apply_friction(0.4, delta)
	behaviour(delta)
	wishdir = Vector3(cmd.right_move, 0, cmd.forward_move)
	wishdir = - get_transform().basis.xform(wishdir)
	
	var wishspeed = wishdir.length()
	wishspeed *= move_speed
	
	wishdir = wishdir.normalized()
	move_direction_norm = wishdir
	
	var wishspeed2 = wishspeed
	if enemy_velocity.dot(wishdir) < 0:
		accel = air_deacceleration
	else :
		accel = air_acceleration
	
	if cmd.forward_move == 0 and cmd.right_move == 0:
		if wishspeed > side_strafe_speed:
			wishspeed = side_strafe_speed
		accel = side_strafe_acceleration
	
	accelerate(wishdir, wishspeed, accel, delta)
	if air_control:
		air_control(wishdir, wishspeed, delta)

func air_control(wishdir, wishspeed, delta):
	var zspeed
	var speed
	var dot
	var k
	var i
	
	if cmd.forward_move == 0 or wishspeed == 0:
		return 
	zspeed = enemy_velocity.y
	enemy_velocity.y = 0
	
	speed = enemy_velocity.length()
	enemy_velocity = enemy_velocity.normalized()
	
	dot = enemy_velocity.dot(wishdir)
	k = 32
	k *= air_control * dot * dot * delta
	
	if dot > 0:
		enemy_velocity.x = enemy_velocity.x * speed + wishdir.x * k
		enemy_velocity.y = enemy_velocity.y * speed + wishdir.y * k
		enemy_velocity.z = enemy_velocity.z * speed + wishdir.z * k
		
		enemy_velocity = enemy_velocity.normalized()
		move_direction_norm = enemy_velocity
	
	enemy_velocity.x *= speed
	enemy_velocity.y = zspeed
	enemy_velocity.z *= speed

func ground_move(delta):
	var wishdir
	
	if not wish_jump:
		apply_friction(1.0, delta)
	else :
		apply_friction(1.0, delta)
	
	behaviour(delta)
	
	wishdir = Vector3(cmd.right_move, 0, cmd.forward_move)
	wishdir = get_transform().basis.xform(wishdir)
	wishdir = wishdir.normalized()
	move_direction_norm = wishdir
	
	var wishspeed = wishdir.length()
	wishspeed *= move_speed
	
	accelerate(wishdir, wishspeed, run_acceleration, delta)
	
	enemy_velocity.y = 0
	
	if (wish_jump):
		enemy_velocity.y = jump_speed
		wish_jump = false

func apply_friction(t, delta):
	var vec = enemy_velocity
	var vel
	var speed
	var newspeed
	var control
	var drop
	
	vec.y = 0.0
	speed = vec.length()
	drop = 0.0
	
	if is_on_floor() or is_on_wall():
		control = run_deacceleration if speed < run_deacceleration else speed
		drop = control * friction * delta * t
	
	newspeed = speed - drop
	enemy_friction = newspeed
	if newspeed < 0:
		newspeed = 0
	if speed > 0:
		newspeed /= speed
	
	enemy_velocity.x *= newspeed
	enemy_velocity.z *= newspeed

func accelerate(wishdir, wishspeed, accel, delta):
	var addspeed
	var accelspeed
	var currentspeed
	
	currentspeed = enemy_velocity.dot(wishdir)
	
	addspeed = wishspeed - currentspeed
	if addspeed <= 0:
		return 
	accelspeed = accel * delta * wishspeed
	if accelspeed > addspeed:
		accelspeed = addspeed
	enemy_velocity.x += accelspeed * wishdir.x
	enemy_velocity.z += accelspeed * wishdir.z

func look():
	if player_ray.get_collider() == player and in_view and fmod(time, 100) == 0:
		player_last_seen = player_ray.get_collision_point()
	var camera_rot = rotation_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, - 45, 45)
	rotation_helper.rotation_degrees = camera_rot
	
	if player_last_seen != null and global_transform.origin.distance_to(player_last_seen) > 1:
		if in_view or not $Chase_Timer.is_stopped():
			look_at(Vector3(player_last_seen.x, global_transform.origin.y, player_last_seen.z), Vector3.UP)
			rotation.x = initrotx
			rotation_helper.look_at(player_last_seen, Vector3.UP)
	if player != null:
		player_ray.look_at(player.global_transform.origin + Vector3(0, 1.5, 0), Vector3.UP)

func add_velocity(velocity):
	enemy_velocity -= velocity
	
	player_last_seen

func get_direction():
	return Vector3(cmd.right_move, 0, cmd.forward_move)

func get_look_at():
	return transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z), Vector3.UP)
	
func get_leg_rotation():
	if player_last_seen != null:
		var a = global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z) + Vector3(enemy_velocity.x, 0, enemy_velocity.z) * 0.7, Vector3.UP)
		return a
	else :
		return global_transform

func get_torso_rotation():
	if player_last_seen != null:
		var a = rotation_helper.global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y + 0.2, player_last_seen.z), Vector3.UP)
		return a
	else :
		return global_transform

func get_body_transform():
	return transform.basis

func set_flee():
	flee = true

func set_dead():
	if not dead:
		dead = true
		weapon.hide()
		set_animation(DEATH_ANIMS[randi() % DEATH_ANIMS.size()], 1)

func _on_Sight_Cone_body_entered(body):
	if body == player:
		in_view = true

func _on_Sight_Cone_body_exited(body):
	if body == player:
		in_view = false
		$Chase_Timer.start(4)
