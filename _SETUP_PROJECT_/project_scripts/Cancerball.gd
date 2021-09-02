extends StaticBody






var damaged_count = 0
var wall_hit = false
var count = 0
var health = 25
var dir = Vector3.UP * 0.4
var new_orb
var gib = [preload("res://Entities/Physics_Objects/Chest_Gib.tscn"), 
			preload("res://Entities/Physics_Objects/Leg_Gib.tscn"), 
			preload("res://Entities/Physics_Objects/Arm_Gib.tscn"), 
			preload("res://Entities/Physics_Objects/Head_Gib.tscn")]
onready  var mesh = $MeshInstance


func _cancer_id():
	pass
func _ready():
	if Engine.get_frames_per_second() > 30:
		$Audio.play()
	count += 1
	damaged_count = count
	new_orb = self.duplicate()
	
	if wall_hit or count > 10:
		new_orb.wall_hit = true
		return 
	yield (get_tree(), "idle_frame")
	
	new_orb.count = count
	dir = dir.rotated(Vector3.UP, rand_range( - 0.5, 0.5))
	dir = dir.rotated(Vector3.FORWARD, rand_range( - 0.5, 0.5))
	dir = dir.rotated(Vector3.LEFT, rand_range( - 0.5, 0.5))
	add_child(new_orb)
	var v = cos(count) * 0.6 + 2
	new_orb.mesh.scale = Vector3(v, v, v)
	new_orb.global_transform.origin = global_transform.origin
	new_orb.dir = dir
	new_orb.global_transform.origin += dir
	




func recursive_search(child):
	var d
	for c in child.get_children():
		if c.has_method("damage"):
			d = recursive_search(c)
	if d == null:
		return child


func damage(damage, n, p, shooterpos):
	yield (get_tree(), "idle_frame")
	var target
	for c in get_children():
		if c.get_class() == "StaticBody":
			target = c
	if target != null:
		target.damaged_count = count
		target.damage(100, n, p, shooterpos)
		var v = sin(target.count) * 0.2 + 1
		target.mesh.scale = Vector3(v, v, v)
	else :
		if get_parent().has_method("damage") and get_parent().count >= get_parent().damaged_count:
			
			get_parent().damaged_count = damaged_count
			get_parent().damage(100, n, p, shooterpos)
			if fmod(count, 3) == 0:
				var new_gib = gib[randi() % gib.size()].instance()
				var audio = $Audio.duplicate()
				Global.player.get_parent().get_parent().get_parent().add_child(audio)
				audio.global_transform.origin = global_transform.origin
				audio.play()
				Global.player.get_parent().get_parent().get_parent().add_child(new_gib)
				new_gib.global_transform.origin = global_transform.origin
				new_gib.velocity = Vector3(rand_range( - 10, 10), rand_range( - 10, 10), rand_range( - 10, 10))
		queue_free()
func get_type():
	return 0

func _on_Cancerball_body_entered(body):
	if wall_hit:
		return 
	if body.get_collision_layer_bit(0) and not body.has_method("_cancer_id"):
		wall_hit = true
		queue_free()
			
		return 
	elif body.has_method("cancer"):
		pass
		



func _on_Area_body_entered(body):
	pass
