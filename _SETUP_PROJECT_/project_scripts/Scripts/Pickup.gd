extends KinematicBody





var velocity = Vector3(0, 0, 0)
var gravity = 22
export  var health_kit = false
export  var ammo_box = false
export  var health = 50
export  var shotgun_ammo = 0
export  var pistol_ammo = 0
export  var smg_ammo = 0
export  var rocket_ammo = 0
export  var particle = false
export  var mass = 1
export  var shell = false
var t = 0
var finished = false


func _enter_tree():
	queue_free()
func _ready():
	queue_free()
	t += rand_range(0, 10)



func _physics_process(delta):
	if finished:
		return 
	if not shell or t < 200:
		t += 1
		var collision = move_and_collide(velocity * delta)
		if collision and t < 200:
			velocity = velocity.bounce(collision.normal) * 0.6
		elif collision and t >= 200:
			
			if particle:
				$Particle.emitting = false
				$Particle.hide()
			finished = true
		velocity.y -= gravity * delta

func damage(damage, collision_n, collision_p, shooter_pos):
	randomize()
	velocity -= collision_n * damage / mass


func _on_Area_body_entered(body):
	if body.health < 100 and health_kit:
		body.add_health(health)
		queue_free()
	if ammo_box:
		body.weapon.add_ammo(pistol_ammo, 0, self)
		body.weapon.add_ammo(smg_ammo, 1, self)
		body.weapon.add_ammo(shotgun_ammo, 2, self)
		body.weapon.add_ammo(rocket_ammo, 3, self)
