extends "res://Scripts/Kinematic_Physics_Object.gd"

var sound
var no_rotation = true

func _ready():
	particle = false
	collidable = true
	rotate_b = false
	stay_active = true
	mass = 10
	set_collision_layer_bit(0, 1)
	set_collision_layer_bit(8, 1)
	sound = AudioStreamPlayer3D.new()
	add_child(sound)
	sound.global_transform.origin = global_transform.origin
	sound.stream = load("res://Sfx/footstep.wav")
	impact_sound = [sound]
	sounds = true
	set_safe_margin(1e-06)
	no_rot = true
func _physics_process(delta):
	alerter = false
