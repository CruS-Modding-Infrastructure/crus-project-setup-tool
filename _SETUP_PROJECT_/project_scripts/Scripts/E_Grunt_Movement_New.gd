extends KinematicBody

var rotation_helper:Spatial
var player_ray:RayCast
var held = false
var alerter = false
var velocity_ray:RayCast
var in_sight:bool
var in_view:bool = false
var weapon:Spatial
export  var no_patrol = false
export  var ai_distance = 100
var rotate_towards:Vector3 = Vector3(0, 0, 0)
var rand_rot:Vector3 = Vector3(0, 0, 0)
var anim_player:AnimationPlayer
var footstep:AudioStreamPlayer3D
var anim_counter = 0
var alerted = false
var movement_sound:AudioStreamPlayer3D
export  var melee = false
export  var rotate = true
export  var crusher = false
export  var wait_sound = false
export  var path_finding_size_modifier:float = 0
const DEATH_ANIMS:Array = ["Death1", "Death2"]
var burst_counter = 0
var burst_reloading = false
export  var burst = false
export  var patrol = false
export  var burst_size = 15

var alerted_counter = 0
var tranq = false
var player:Spatial
var player_last_seen:Vector3
var player_spotted:bool = false
var reaction_timer:float = 0
var navigation:Navigation
var last_seen_n:Vector3
var time:float = 0
var dead:bool = false
var active:bool = false
var line_of_sight:float
var line_of_sight_y:float
var heading:Vector3
var heading_y:Vector3
var spot_time = 0.5
var sight_potential = false
var has_anim_attack
export  var fix_helper_pos = true
export  var engage_distance:float = 7
export  var pathing_frequency:float = 100
export  var reaction_time:float = 9
export  var gravity:float = 22
export  var friction:float = 6
var knocksound
export  var move_speed:float = 4.5
export  var jump_speed:float = 7
var rand_patroller = false
var height_difference:bool = false
var velocity:Vector3 = Vector3(0, 0, 0)
var footstep_counter = 0
var muzzleflash
var flee:bool = false
var path:Array
var pos1
var pos2
var alertness = 100
var forward_helper:Position3D
var pos_flag = false
var player_distance = Vector3.ZERO
var shoot_mode:bool = false
onready  var painsound = $SFX / Pain1
export  var civ_killer = false

onready  var soul:Spatial = get_parent()
var following_path:bool = false
var tranqtimer:Timer
var stealthed
var nearby:Array = []
var glob

func _ready()->void :
	glob = Global
	forward_helper = Position3D.new()
	add_child(forward_helper)
	forward_helper.transform.origin = Vector3.FORWARD
	tranqtimer = Timer.new()
	add_child(tranqtimer)
	tranqtimer.wait_time = 60
	tranqtimer.one_shot = true
	tranqtimer.connect("timeout", self, "tranq_timeout")
	spot_time += glob.implants.torso_implant.camo
		
	if move_speed != 0:
		move_speed += rand_range( - 1, 1)
	alertness = floor(rand_range(50, 200))
	if (randi() % 2 == 0 or Global.chaos_mode) and not crusher and move_speed != 0 and not wait_sound and not no_patrol:
		rand_patroller = true
		pos1 = global_transform.origin
		pos2 = pos1 + (Vector3.FORWARD * 5).rotated(Vector3.UP, deg2rad(rand_range(0, 360)))
	if wait_sound:
		knocksound = get_node("Knocksound")
	movement_sound = get_node_or_null("Movement_Sound")
	anim_player = get_parent().get_node("Nemesis/AnimationPlayer")
	
	footstep = AudioStreamPlayer3D.new()
	add_child(footstep)
	footstep.global_transform.origin = global_transform.origin
	footstep.stream = load("res://Sfx/wood01.wav")
	footstep.unit_size = 5
	footstep.bus = "step"
	randomize()
	time = round(rand_range(1, 100))
	set_process(false)
	if rotate:
		look_at(global_transform.origin + Vector3(rand_range( - 1, 1), 0, rand_range( - 1, 1)), Vector3.UP)
	player = glob.player
	if player:
		player_distance = global_transform.origin.distance_to(player.global_transform.origin)
	navigation = glob.nav
	player_ray = $Player_Ray
	player_ray.transform.origin.z = 0
	velocity_ray = $Velocity_Ray
	
	last_seen_n = Vector3.ZERO
	in_sight = false
	weapon = $Rotation_Helper / Weapon
	rotation_helper = $Rotation_Helper
	if fix_helper_pos:
		rotation_helper.translation.z = 0
	muzzleflash = get_node_or_null("Muzzleflash")
	
	if move_speed != 0:
		path = navigation.get_simple_path(global_transform.origin, global_transform.origin)
	
	has_anim_attack = anim_player.has_animation("Attack")
	
	if patrol:
		var space_state = get_world().direct_space_state
		var dir = randi() % 3
		var offset = Vector3(0, 0, 0)
		match dir:
			0:
				offset = Vector3(500, 0, 0)
			1:
				offset = Vector3( - 500, 0, 0)
			2:
				offset = Vector3(0, 0, 500)
			3:
				offset = Vector3(0, 0, - 500)
		var result = space_state.intersect_ray(global_transform.origin, global_transform.origin + offset)
		if result:
			path = navigation.get_simple_path(global_transform.origin, navigation.get_closest_point(result.position))
		find_path(get_physics_process_delta_time())
	stealthed = glob.implants.torso_implant.stealth and global_transform.origin.distance_to(glob.player.global_transform.origin) > 20
	yield (get_tree(), "idle_frame")
	nearby = soul.new_alert_sphere.get_overlapping_bodies()
	move()

func _physics_process(delta)->void :
	if player == null:
		return 
	if global_transform.origin.distance_to(player.global_transform.origin) > glob.draw_distance + 10:
		return 
		
	if Global.every_20:
		player_distance = global_transform.origin.distance_to(player.global_transform.origin)
		stealthed = glob.implants.torso_implant.stealth and player_distance > 20
	if civ_killer:
		player_spotted = true
	var fps = Global.fps
	
	if fps < 30:
		if Global.every_2:
			return 
		if player_distance > 30:
			return 
	
	height_difference = player.global_transform.origin.y > global_transform.origin.y and abs(player.global_transform.origin.y - global_transform.origin.y) > 21
	anim_counter += 1
	time += 1
	if muzzleflash:
		muzzleflash.hide()
	if player_distance > ai_distance:
		return 
	if player_distance > 50 and Global.every_2:
		return 
	elif player_distance > 50 and not Global.every_2:
		delta *= 2
	
	
	if Global.every_55:
		if randi() % 2 == 1:
			shoot_mode = true
		elif not civ_killer:
			shoot_mode = false
	
	if move_speed == 0:
		if player_spotted and not dead and not tranq:
			rotate_towards = lerp(rotate_towards, player.global_transform.origin, 6 * delta)
			look_at(rotate_towards, Vector3.UP)
			rotation.x = 0
		shoot_mode = true
	
	if not player_spotted and not dead and not tranq and (player_distance < 40 or move_speed != 0):
		wait_for_player(delta)
	
	track_player(delta)
	
	if not sight_potential and player_distance > 20 and fmod(time, 20) != 0 and not alerted and not player_spotted:
		return 
	
	if fmod(time, 5) == 0 and sight_potential:
		heading = - Vector3(player.global_transform.origin.x, 0, player.global_transform.origin.z).direction_to(Vector3(global_transform.origin.x, 0, global_transform.origin.z))
		
		line_of_sight = global_transform.origin.direction_to(forward_helper.global_transform.origin).dot(heading)
		heading_y = (player.global_transform.origin - global_transform.origin).normalized()
		line_of_sight_y = transform.basis.xform(Vector3.UP).dot(heading_y)
	
	if fmod(time, 20) == 0 and player_distance < 30:
		if velocity_ray.is_colliding():
			var collider = velocity_ray.get_collider()
			var normal = velocity_ray.get_collision_normal()
			var point = velocity_ray.get_collision_point()
			if is_instance_valid(collider):
				if collider.has_method("use") and collider.has_method("destroy") and not collider.get_collision_layer_bit(6) and (alerted or player_spotted):
					collider.destroy(normal, point)
				elif rand_patroller and collider.has_method("destroy") and collider.has_method("use") and ( not alerted and not player_spotted) and not pos_flag:
					if pos_flag:
						path = navigation.get_simple_path(global_transform.origin, pos2)
						pos_flag = not pos_flag
					else :
						path = navigation.get_simple_path(global_transform.origin, pos1)
						pos_flag = not pos_flag
				elif collider.has_method("use") and not collider.has_method("destroy") and not collider.get_collision_layer_bit(6) and Vector2(velocity.x, velocity.z).length() > 0.2:
					collider.use()
				elif collider.has_method("piercing_damage") and player_spotted:
					collider.piercing_damage(200, normal, point, global_transform.origin)
	velocity.y -= gravity * delta
	if not dead and not tranq:
		if player_spotted:
			player_spotted()
		
		if path.size() > 0 and ((player_distance > engage_distance and ( not shoot_mode or melee)) or not in_sight) and player_spotted:
				find_path(delta)
		else :
			if in_sight:
				active(delta)
			else :
				reaction_timer = clamp(reaction_timer, 0, reaction_time + 1) - 5 * delta
	elif is_on_floor():
			velocity.x *= 0.95
			velocity.z *= 0.95
	move()


func move()->void :
	if crusher:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider != null:
				if collision.collider.has_method("damage") and Vector3(velocity.x, 0, velocity.y).length() > 2:
					collision.collider.damage(100, collision.normal, collision.position, global_transform.origin)
	
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 0.785398)

func wait_for_player(delta)->void :
	if not patrol:
		if move_speed == 0:
			anim_player.play("Idle", - 1, 1)
		
		if is_on_floor():
			velocity.y = 0
		
		if path.size() == 0:
			anim_player.play("Idle", - 1, 1)
			if fmod(time, alertness) == 0:
				alerted = false
				if rand_patroller and randi() % 5 == 1:
					
					if pos_flag:
						path = navigation.get_simple_path(global_transform.origin, pos2)
						pos_flag = not pos_flag
					else :
						path = navigation.get_simple_path(global_transform.origin, pos1)
						pos_flag = not pos_flag
				rand_rot = global_transform.origin + Vector3.FORWARD.rotated(Vector3.UP, rand_range( - PI, PI))
			rotate_towards = lerp(rotate_towards, rand_rot, (6 * delta - (deg2rad(abs(rotate_towards.angle_to(rand_rot))) * delta)) * 0.1)
			if rotate:
				look_at(rotate_towards, Vector3.UP)
			rotation.x = 0
			rotation.z = 0
			velocity.x = 0
			velocity.z = 0
		elif move_speed != 0:
			find_path(delta)
	else :
		if path.size() < 10:
			var space_state = get_world().direct_space_state
			var dir = randi() % 3
			var offset = Vector3(0, 0, 0)
			match dir:
				0:
					offset = Vector3(500, 0, 0)
				1:
					offset = Vector3( - 500, 0, 0)
				2:
					offset = Vector3(0, 0, 500)
				3:
					offset = Vector3(0, 0, - 500)
			var result = space_state.intersect_ray(global_transform.origin, global_transform.origin + offset)
			if result:
				path = navigation.get_simple_path(global_transform.origin, result.position)
		
		if path.size() > 0:
			find_path(delta)


func anim()->void :
	pass










func set_animation(anim:String, speed:float)->void :
	anim_player.play(anim)
	anim_player.playback_speed = speed

func track_player(delta)->void :
	
	var player_offset = Vector3(0, 1.5, 0)
	if civ_killer:
		player_offset = Vector3(0, - 1.5, 0)
	if glob.menu.in_game:
		if glob.player.crouch_flag:
			player_offset = Vector3(0, 0.7, 0)
	if "aim_point" in player: # not vanilla, fix for intro
		player_ray.look_at(player.aim_point.global_transform.origin, Vector3.UP)
	#else:
		
	if player_ray.is_colliding() and not dead and not tranq:
		var collider = player_ray.get_collider()
		
		if collider == player:
			sight_potential = true
		if collider == player and line_of_sight > 0 and not height_difference and line_of_sight_y < 0.8 and not stealthed:
			if not civ_killer and "UI" in glob.player: # not vanilla, fix for intro
				glob.player.UI.set_in_sight(true)
			if soul.psychosis_inducer:
				glob.player.set_psychosis(true)
			spot_time -= delta
			if spot_time < 0:
				
				in_sight = true
				player_spotted = true
				soul.set_stealth()
				if wait_sound:
					if is_instance_valid(knocksound):
						$Knocksound.queue_free()
				
				rotation_helper.look_at(player.global_transform.origin + Vector3(0, 2, 0), Vector3.UP)
		elif collider != player:
			in_sight = false
			sight_potential = false
	if not in_sight and player_spotted:
		alerted_counter += 1
		if alerted_counter > 2000:
			player_spotted = false
			alerted_counter = 0
			velocity = Vector3.ZERO
	if in_sight:
		alerted_counter = 0

func player_spotted()->void :
	
	glob.action_lerp_value += 1
	if fmod(time, pathing_frequency) == 0:
		var new_path = navigation.get_simple_path(global_transform.origin, player.global_transform.origin)
		if new_path.size() > 0:
			path = new_path
	elif fmod(time, pathing_frequency) and path.size() == 0:
		path = navigation.get_simple_path(global_transform.origin, global_transform.origin + Vector3(rand_range( - 3, 3), 0, rand_range( - 3, 3)))

func add_velocity(incvelocity:Vector3)->void :
	velocity -= incvelocity
	
	
	if not dead and not tranq:
		yield (get_tree(), "idle_frame")
		alert(player.global_transform.origin)
		if not player_spotted:
			player_spotted = true
			look_at(player.global_transform.origin, Vector3.UP)
			rotation.x = 0
	
func alert(pos:Vector3)->void :
	if player_spotted or alerted or dead or tranq:
		return 
	randomize()
	var new_pos = pos + Vector3(rand_range( - 3, 3), 0, rand_range( - 3, 3))
	var new_path = navigation.get_simple_path(global_transform.origin, new_pos)
	if new_path.size() > 0:
		path = new_path
	else :
		return 
	
	alerted = true




	
	if not dead and not tranq:
		painsound.play()








func active(delta:float)->void :
	
	if burst_counter >= burst_size:
		burst_reloading = true
	if burst_counter <= 0:
		burst_reloading = false
	if burst_reloading:
		burst_counter -= delta * 10
	reaction_timer = clamp(reaction_timer, 0, reaction_time + 1) + 15 * delta
	rotate_towards = lerp(rotate_towards, player.global_transform.origin, 5 * delta)
	look_at(rotate_towards, Vector3.UP)
	rotation.x = 0
	var player_pos = player.global_transform.origin + Vector3(0, 1.5, 0)
	if "aim_point" in player: # not vanilla, fix for intro
		player_pos = player.aim_point.global_transform.origin
	rotation_helper.look_at(player_pos, Vector3.UP)
	if reaction_timer > reaction_time:
		if (burst_counter <= burst_size and not burst_reloading) or civ_killer:
			burst_counter += delta * 10
			weapon.AI_shoot()
	if is_on_floor():
		velocity.x = 0
		velocity.z = 0
	if not has_anim_attack:
		anim_player.play("Idle")

func find_path(delta)->void :
	
	if move_speed == 0:
		anim_player.play("Idle")
		return 
	if civ_killer:
		weapon.AI_shoot()
	
	if anim_player.current_animation != "Attack":
			if Vector2(velocity.x, velocity.z).length() > 0.3:
				var anim_speed = 2
				if not player_spotted:
					anim_speed = 1
				anim_player.play("Run", - 1, anim_speed)
			else :
				anim_player.play("Idle")
			if is_instance_valid(movement_sound):
				if fmod(time, 5) == 0:
					movement_sound.pitch_scale = clamp(sin(time * 0.3) + 0.7, 0.5, 2)
				if not movement_sound.playing and Vector2(velocity.x, velocity.z).length() > 0.6:
					movement_sound.play()
				
			footstep_counter += delta
			if not footstep.playing and footstep_counter < 40 - move_speed:
				footstep.pitch_scale = 1 + rand_range( - 0.2, 0.2)
				footstep.play()
				footstep_counter = 0
	var next_position = path[0]
	var move_to
	if player_distance < 50:
		move_to = lerp(global_transform.origin, next_position, delta)
	else :
		move_to = next_position
	if global_transform.origin.direction_to(move_to) != Vector3.UP:
		rotate_towards = lerp(rotate_towards, move_to + velocity, 5 * delta)
		
		if abs(global_transform.origin.direction_to(rotate_towards).y) != 1:
			look_at(rotate_towards, Vector3.UP)
	rotation.x = 0
	var dir = - (global_transform.origin * Vector3(1, 0, 1)).direction_to(move_to * Vector3(1, 0, 1))
	if is_on_floor():
		var multiplier
		if player_spotted:
			multiplier = 1
		else :
			multiplier = 0.33
		velocity = lerp(velocity, - (move_speed * multiplier) * Vector3(dir.x, 1, dir.z), 5 * delta)
	if global_transform.origin.distance_to(next_position) < 1 + path_finding_size_modifier:
		path.pop_front()

func get_look_at()->Transform:
	return transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z), Vector3.UP)
	
func get_leg_rotation()->Transform:
	if player_last_seen != null:
		var a = global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y, player_last_seen.z) + Vector3(velocity.x, 0, velocity.z) * 0.7, Vector3.UP)
		return a
	else :
		return global_transform

func get_torso_rotation()->Transform:
	if player_last_seen != null:
		var a = rotation_helper.global_transform.looking_at(Vector3(player_last_seen.x, player_last_seen.y + 0.2, player_last_seen.z), Vector3.UP)
		return a
	else :
		return global_transform

func get_body_transform()->Basis:
	return transform.basis

func set_flee()->void :
	flee = true

func set_dead()->void :
	if not dead:
		dead = true
		weapon.hide()
		if not tranq:
			var anim = DEATH_ANIMS[randi() % DEATH_ANIMS.size()]
			if anim_player.has_animation(anim):
				set_animation(anim, 1)
func set_tranquilized():
	if not tranq:
		tranq = true
		if anim_player.has_animation(DEATH_ANIMS[0]):
			set_animation(DEATH_ANIMS[0], 1)
		tranqtimer.start()

func tranq_timeout():
	if dead:
		return 
	if anim_player.has_animation(DEATH_ANIMS[0]):
		anim_player.play_backwards(DEATH_ANIMS[0])
	while (anim_player.is_playing() and anim_player.current_animation == DEATH_ANIMS[0]):
		yield (get_tree(), "physics_frame")
	tranq = false
	set_collision_layer_bit(4, true)
	flee = false









