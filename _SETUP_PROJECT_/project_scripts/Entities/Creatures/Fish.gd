extends Spatial
var speed:float = 1
var time:float = 0
var velocity:Vector3 = Vector3(0, 0, 0)
var type = 0
var gib_flag = false

var gib = preload("res://Entities/Physics_Objects/Fish_Gib.tscn")
func _ready():
	pass

func _physics_process(delta):
	$AnimationPlayer.play("ArmatureAction")
	time += delta
	velocity.x = sin(time * speed * 0.5) * speed * 0.5
	velocity.z = cos(time * speed) * speed * 0.5
	$Armature.look_at(global_transform.origin - velocity, Vector3.UP)
	$CollisionShape.transform.basis = $Armature.transform.basis
	$CollisionShape.transform.origin = $Armature.transform.origin
	translate(velocity * delta)
	
	
func damage(damage, collision_n, collision_p, shooter_pos):
	if gib_flag:
		return 
	gib_flag = true
	var new_gib = gib.instance()
	get_parent().add_child(new_gib)
	new_gib.global_transform.origin = global_transform.origin
	new_gib.damage(damage, collision_n, collision_p, shooter_pos)
	queue_free()

func get_type():
	return type;
