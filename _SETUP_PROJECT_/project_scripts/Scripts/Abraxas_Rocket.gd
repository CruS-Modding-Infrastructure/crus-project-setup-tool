extends KinematicBody

var health = 300
var type = 1
var frequency = 50
var destroyed = false
var disabled = true
var BULLETS = preload("res://Entities/Bullets/Homing_Missile.tscn")
var t = 0
var activated = false

func _ready():
	pass

func _physics_process(delta):
	t += 1
	if destroyed:
		return 
	if disabled:
		return 
	show()
	if not activated and fmod(t, 50) == 0:
		var space = get_world().direct_space_state
		var result = space.intersect_ray(global_transform.origin, Global.player.global_transform.origin + Vector3.UP * 0.5, [self])
		if result:
			if result.collider == Global.player:
				activated = true
	if activated:
		if fmod(t, frequency) == 0:
			for i in range(4):
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				yield (get_tree(), "idle_frame")
				rocket_launcher()

func rocket_launcher()->void :
	var missile_new = BULLETS.instance()
	get_parent().get_parent().get_parent().add_child(missile_new)
	missile_new.add_collision_exception_with(self)
	missile_new.global_transform.origin = global_transform.origin
	missile_new.set_velocity(30, (global_transform.origin - (Global.player.global_transform.origin + Vector3.UP * 50 + Vector3(0, 0, sin(t * 0.5) * 25))).normalized(), global_transform.origin)

func damage(dmg, nrml, pos, shoot_pos):
	if not activated:
		return 
	health -= dmg
	if health <= 0:
		destroyed = true
		get_parent().get_node("Sphere001").hide()
		get_parent().get_node("Particle").show()

func get_type():
	return type;
