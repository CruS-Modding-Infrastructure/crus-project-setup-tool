extends KinematicBody

export  var door_health = 100
export  var speed = 2
var open = false
var stop = true
var initrot = rotation
var movement_counter = 0
var mesh_instance
var collision_shape
var collision = false
var found_overlap
var sfx = preload("res://Sfx/Environment/door_concrete.wav")
var audio_player:AudioStreamPlayer3D

func _ready():
	audio_player = AudioStreamPlayer3D.new()
	audio_player.stream = sfx
	add_child(audio_player)
	for child in get_children():
		if child is MeshInstance:
			mesh_instance = child
		if child is CollisionShape:
			collision_shape = child
	var t = mesh_instance.transform
	global_transform.origin.x -= mesh_instance.get_aabb().position.x
	global_transform.origin.z -= mesh_instance.get_aabb().position.z
	t = t.translated(Vector3(mesh_instance.get_aabb().position.x, 0, mesh_instance.get_aabb().position.z))
	mesh_instance.transform = t
	collision_shape.transform = t




		

func _physics_process(delta):
	if stop and not open and Global.objective_complete:
		open = not open
		stop = not stop
	if not open and not stop:
		if not audio_player.playing:
			audio_player.play()
		translation.y += speed * delta
		movement_counter += speed * delta
	if open and not stop:
		if not audio_player.playing:
			audio_player.play()
		translation.y += speed * delta
		movement_counter += speed * delta
	if movement_counter > mesh_instance.get_aabb().size.y + 0.1:
		audio_player.stop()
		movement_counter = 0
		stop = true









