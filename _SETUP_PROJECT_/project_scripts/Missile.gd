extends Area





var speed = 10
var velocity = Vector3(0, 0, 1)
onready  var explosion = preload("res://Entities/Bullets/Explosion.tscn")


func _ready():
	
	pass



func _physics_process(delta):
	if velocity.length() < 100:
		velocity *= 1.2
	translate(velocity * delta)
	
	
	
func set_velocity(new_velocity, direction):
	velocity = new_velocity * velocity
	transform.basis = direction

func _on_Spatial_body_entered(body):
	var new_explosion = explosion.instance()
	new_explosion.global_transform.origin = global_transform.origin - Vector3(0, 0, 0)
	body.add_child(new_explosion)
	
	$CollisionShape.disabled = true


func _on_Spatial_area_entered(area):
	var distance = global_transform.origin - area.global_transform.origin
	var new_explosion = explosion.instance()
	area.add_child(new_explosion)
	new_explosion.global_transform.origin = global_transform.origin
	new_explosion.global_transform.origin.z = global_transform.origin.z - distance.z * 2
	new_explosion.global_transform.origin.x = global_transform.origin.x - distance.x * 2
	$CollisionShape.disabled = true





