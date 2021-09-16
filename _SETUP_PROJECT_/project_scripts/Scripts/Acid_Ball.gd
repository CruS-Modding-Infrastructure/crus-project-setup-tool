extends KinematicBody

var velocity = Vector3(1, 1, 1)
var gravity = 22
export var particle = true
export var mass = 1
export var shell = false
export var stay_active = false
var impact_sound:Array
export  var sounds = false
var rot_changed = Vector3(0, 0, 0)
var t = 0
var water = false
var finished = false
var acid = preload("res://Entities/Bullets/Acid.tscn")
onready var mesh = $MeshInstance

func _ready():
	set_collision_layer_bit(6, 1)
	set_collision_layer_bit(0, 0)
	t += rand_range(0, 10)
	if sounds:
		impact_sound = [$Sound1, $Sound2, $Sound3]
		for sound in impact_sound:
			sound.pitch_scale -= mass * 0.1

func _physics_process(delta):
	if water:
		gravity = 2
	else :
		gravity = 5
	t += 1
	mesh.scale += Vector3.ONE * 0.01
	
	var collision = move_and_collide(transform.basis.z * - 10 * delta * velocity)
	if collision:
		if collision.collider.has_method("damage"):
			var new_acid = acid.instance()
			collision.collider.add_child(new_acid)
			new_acid.global_transform.origin = collision.position
		queue_free()















	velocity.y -= gravity * delta





	
func set_water(a):
	water = a
	velocity *= 0.5
	velocity.y = 0

func set_velocity(new_velocity, direction):
	transform.basis = direction
	rotation.x += rand_range(0, 0.5)
	rotation.z += rand_range(0, 0.5)
	rotation.y += rand_range( - 0.25, 0.25)
