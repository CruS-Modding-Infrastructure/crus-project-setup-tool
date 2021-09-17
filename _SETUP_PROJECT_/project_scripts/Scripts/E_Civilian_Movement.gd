extends KinematicBody

var rotation_helper
var player_ray
var velocity_ray
var in_sight
var weapon
var anim_player
var anim_tree
const DEATH_ANIMS = ["Death1", "Death2"]

var player
var player_spotted = false
var player_last_seen
var last_seen_n
var time = 0
var dead = false
var rotate_towards = 0

export  var gravity = 22
export  var friction = 6
export  var run_speed = 4.5
export  var walk_speed = 2
export  var move_speed = 2
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
var stop_moving = false
var reaction_timer = 0
var enemy_friction = 0
onready var soul = get_parent()

class Cmd:
	var forward_move:float
	var right_move:float
	var up_move:float

var cmd
var initrotx

var path
var navigation
var following_path = false


func _ready():
	randomize()
	time = round(rand_range(1, 100))
	look_at(global_transform.origin + Vector3(rand_range( - 1, 1), 0, rand_range( - 1, 1)), Vector3.UP)
	initrotx = rotation.x
	player = Global.player
	player_ray = $Player_Ray
	navigation = Global.nav
	velocity_ray = $Velocity_Ray
	player_last_seen = global_transform.origin
	last_seen_n = Vector3.ZERO
	in_sight = false
	weapon = $Rotation_Helper / Weapon
	weapon.queue_free()
	rotation_helper = $Rotation_Helper
	cmd = Cmd.new()
	anim_player = get_parent().get_node("Nemesis/AnimationPlayer")
	path = navigation.get_simple_path(global_transform.origin, global_transform.origin)
	anim_player.play("Idle")

func _physics_process(delta):
		if global_transform.origin.distance_to(player.global_transform.origin) > 100:
			return 
		if global_transform.origin.distance_to(player.global_transform.origin) > 25:
			yield (get_tree(), "idle_frame")
			yield (get_tree(), "idle_frame")
		player_ray.look_at(player.global_transform.origin + Vector3(0, 1, 0), Vector3.UP)
		if player_ray.is_colliding() and not player_spotted:
				if player_ray.get_collider() == player:
					player_spotted = true
		time += 1
		enemy_velocity.y -= gravity * delta
		if not dead and player_spotted:
			if not is_on_floor():
						anim_player.play("Jump")
			elif Vector3(enemy_velocity.x, 0, enemy_velocity.z).length() != 0:
				if not flee:
					anim_player.play("Walk", - 1, 1)
				else :
					anim_player.play("Run", - 1, 2)
			else :
				anim_player.play("Idle")
			if flee and fmod(time, 25) == 0:
				path = navigation.get_simple_path(global_transform.origin, global_transform.origin + Vector3(rand_range( - 30, 30), 0, rand_range( - 30, 30)))
			if fmod(time, 100) == 0:
						path = navigation.get_simple_path(global_transform.origin, global_transform.origin + Vector3(rand_range( - 5, 5), 0, rand_range( - 5, 5)))
			
			if player_ray.is_colliding():
				if player_ray.get_collider() == player:
					force_update_transform()
					player_spotted = true
					soul.set_player_seen(true)
					in_sight = true
					rotation_helper.look_at(player.global_transform.origin + Vector3(0, 2, 0), Vector3.UP)
			
			if player_ray.get_collider() != player:
				in_sight = false
				soul.set_player_seen(false)
				
			if path.size() > 0 and (global_transform.origin.distance_to(player.global_transform.origin) > 7 or flee):
				var next_position = path[0]
				if (global_transform.origin - next_position).normalized() != Vector3.UP:
					look_at(next_position, Vector3.UP)
				rotation.x = 0
				var dir = (global_transform.origin - next_position).normalized()
				enemy_velocity = - move_speed * dir
				if global_transform.origin.distance_to(next_position) < 1:
					path.remove(0)
			else :
				if in_sight and not flee:
					
					rotation.x = 0
					enemy_velocity.x = 0
					enemy_velocity.z = 0
				else :
					reaction_timer = clamp(reaction_timer, 0, 10) - 5 * delta
		elif is_on_floor():
				enemy_velocity.x *= 0.95
				enemy_velocity.z *= 0.95
		move_and_slide(enemy_velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(45))

func set_animation(anim, speed):
	anim_player.play(anim)
	anim_player.playback_speed = speed

func behaviour(delta):
	if dead == false:
		velocity_ray.cast_to = Vector3(cmd.right_move, 0, cmd.forward_move)
		if not flee:
			if global_transform.origin.distance_to(player.global_transform.origin) < 5:
				cmd.forward_move = 0
				look()
			else :
				rotation.y = lerp(rotation.y, rotate_towards, 0.9)
				
				move_speed = walk_speed
				if fmod(time, 500) == 0:
					stop_moving = not stop_moving
					rotate_towards = round(rand_range( - PI, PI))
				if stop_moving:
					cmd.forward_move = 0
				else :
					cmd.forward_move = - 1
				if velocity_ray.is_colliding():
					rotate_towards = round(rand_range( - PI, PI))
		else :
			rotation.y = lerp(rotation.y, rotate_towards, 0.9)
			move_speed = run_speed
			cmd.right_move = 0
			cmd.forward_move = - 1
			if fmod(time, 20) == 0:
				rotate_towards = round(rand_range( - PI, TAU))
			if velocity_ray.is_colliding():
				rotate_towards = round(rand_range( - PI, PI))
	else :
		cmd.right_move = 0
		cmd.forward_move = 0

func alert(pos):
	if player_spotted and flee:
		return 
	if not player_spotted:
		player_spotted = true
	if not flee:
		flee = true
		path = navigation.get_simple_path(global_transform.origin, global_transform.origin + Vector3(rand_range( - 30, 30), 0, rand_range( - 30, 30)))
		rotation.y = lerp(rotation.y, rotate_towards, 0.9)
		move_speed = run_speed
		cmd.right_move = 0
		stop_moving = false
		cmd.forward_move = - 1
		randomize()
		yield (get_tree().create_timer(rand_range(0.1, 0.6)), "timeout")
		if not dead:
			$SFX / Pain3.play()
	

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
	if player_ray.get_collider():
		if player_ray.get_collider() == player:
			player_last_seen = player_ray.get_collision_point()
	var camera_rot = rotation_helper.rotation_degrees
	camera_rot.x = clamp(camera_rot.x, - 45, 45)
	rotation_helper.rotation_degrees = camera_rot
	if global_transform.origin != Vector3(player_last_seen.x, global_transform.origin.y, player_last_seen.z):
		look_at(Vector3(player_last_seen.x, global_transform.origin.y, player_last_seen.z), Vector3.UP)
	rotation.x = initrotx
	rotation_helper.look_at(player_last_seen + Vector3(0, 0.1, 0), Vector3.UP)


func add_velocity(velocity):
	enemy_velocity -= velocity
	move_speed = run_speed
	flee = true

func get_direction():
	return Vector3(cmd.right_move, 0, cmd.forward_move)

func get_look_at():
	return transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z), Vector3.UP)
	
func get_leg_rotation():
	var a = global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z) + Vector3(enemy_velocity.x, 0, enemy_velocity.z) * 0.7, Vector3.UP)
	return a

func get_torso_rotation():
	var a = rotation_helper.global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y + 0.2, player_last_seen.z), Vector3.UP)
	return a

func get_body_transform():
	return transform.basis

func set_flee():
	flee = true

func set_dead():
	if not dead:
		dead = true
		set_animation(DEATH_ANIMS[randi() % DEATH_ANIMS.size()], 1)
