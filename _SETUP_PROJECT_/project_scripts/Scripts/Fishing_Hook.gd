extends KinematicBody

var velocity = Vector3.ZERO
var GRAVITY = 22
var parent_weapon
var active = false
var fish_caught = false
var current_fish
var rand_fish
var toilet = false
var distance
var return_fish = false
var finished = false
var water = false
onready  var fishtimer = Timer.new()
onready  var catchtimer = Timer.new()



var collided = false
var fish_index = 0
onready  var raycast:RayCast = $RayCast

func _ready():
	fishtimer.connect("timeout", self, "fish_timeout")
	catchtimer.connect("timeout", self, "catch_timeout")
	catchtimer.one_shot = true
	fishtimer.wait_time = 1
	add_child(fishtimer)
	add_child(catchtimer)

func _physics_process(delta):
	distance = global_transform.origin.distance_to(Global.player.global_transform.origin)
	distance = clamp(distance, 0, 50)
	if not collided and not return_fish:
		velocity.y -= GRAVITY * delta
		var collision = move_and_collide(velocity * delta)
		if collision:
			if collision.collider.get_collision_layer_bit(3):
				collision.collider.soul.add_velocity( - 50, (Global.player.global_transform.origin + Vector3(0, 2, 0) - global_transform.origin).normalized())
			if collision.collider.get_collision_layer_bit(2):
				collision.collider.remove_weapon()
			Global.player.weapon.fishing_hook = null
			queue_free()
	elif return_fish:
		velocity = - (global_transform.origin - (Global.player.global_transform.origin + Vector3.UP * 1.5)).normalized() * (distance + 2)
		global_transform.origin += velocity * delta
		rotation.y += delta * 10
		if global_transform.origin.distance_to(Global.player.global_transform.origin + Vector3.UP * 1.5) < 1 and not finished:
			finished = true




			if Global.STOCKS.FISH_FOUND.find(current_fish.ticker) == - 1:
				Global.STOCKS.FISH_FOUND.append(current_fish.ticker)
			Global.player.UI.notify("Price: $" + str(current_fish.price), Color(1, 1, 0))
			
			Global.player.UI.notify(current_fish.s_name + " obtained!", Color(0.8, 0.9, 1))
			Global.STOCKS.save_stocks("user://stocks.save")
			current_fish.owned += 1
			Global.player.weapon.fishing_hook = null
			queue_free()
			return 
	raycast.cast_to.y = velocity.y * delta
	raycast.force_raycast_update()
	if (raycast.is_colliding() or water) and not return_fish:
		if active:
			return 
		if raycast.is_colliding():
			
			
			global_transform.origin = raycast.get_collision_point()
		collided = true
		if not active:
			fishtimer.start()
			active = true
		
		velocity = Vector3.ZERO

func catch_timeout():
	if return_fish:return 
	fish_caught = false
	$Fish.FISH[fish_index].hide()

func set_water(value):
	water = value

func fish_timeout():
	var time = OS.get_time().hour
	if fish_caught:
		return 
	fish_index = 0
	var index_found = false
	if rand_range(0, 100) > 50:
		if not toilet:
			rand_fish = Global.STOCKS.POSSIBLE_FISH[Global.CURRENT_LEVEL][randi() % Global.STOCKS.POSSIBLE_FISH[Global.CURRENT_LEVEL].size()]
		else :
			rand_fish = Global.STOCKS.TOILET_FISH[randi() % Global.STOCKS.TOILET_FISH.size()]
		toilet = false
		for fish in Global.STOCKS.stocks:
			if fish.asset_type == "fish":

				if fish.ticker == rand_fish:
					current_fish = fish
					index_found = true
					var chnc = fish.fish_chance + distance * 0.1
					if Global.rain:
						chnc += 5
					if Global.implants.head_implant.fishing_bonus:
						chnc += 3.5
					if rand_range(0, 100) > chnc:
						return 
					if fish.fish_night and not (time < 6 or time > 21):
						return 
					if fish.fish_rain and not Global.rain:
						return 
					if fish.fish_hell and not Global.hope_discarded:
						return 
				elif fish.ticker != rand_fish and not index_found:
					fish_index += 1
		fish_caught = true
		$Sound2.play()
		$Particles.emitting = true
		$Fish.FISH[fish_index].show()
		catchtimer.start(current_fish.fish_speed + distance * 0.002)





