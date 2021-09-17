extends KinematicBody

var PARTICLE = preload("res://Entities/Particles/Destruction_Particle.tscn")

export  var door_health = 100
var mesh_instance
var type = 1
var audio_player

func _ready():
	for child in get_children():
		if child is MeshInstance:
			mesh_instance = child
	var t = mesh_instance.transform
	audio_player = AudioStreamPlayer3D.new()
	get_parent().call_deferred("add_child", audio_player)
	yield (get_tree(), "idle_frame")
	audio_player.global_transform.origin = global_transform.origin
	audio_player.stream = load("res://Sfx/Environment/doorkick.wav")
	audio_player.unit_size = 10
	audio_player.unit_db = 2
	audio_player.max_db = 3
	set_collision_layer_bit(8, 1)

func piercing_damage(damage, collision_n, collision_p, shooter_pos):
	door_health -= damage
	if door_health <= 0:
		audio_player.global_transform.origin = collision_p
		audio_player.play()
		var new_particle = PARTICLE.instance()
		get_parent().add_child(new_particle)
		new_particle.global_transform.origin = collision_p
		new_particle.look_at(global_transform.origin + collision_n * 5, Vector3.UP)
		new_particle.material_override = mesh_instance.mesh.surface_get_material(0)
		new_particle.emitting = true
		queue_free()

func player_use():
	Global.player.UI.notify("Small cracks permeate the surface", Color(1, 1, 1))

func get_type():
	return type;
