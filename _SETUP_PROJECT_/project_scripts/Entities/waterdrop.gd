extends Area





var gravityy = 22
var max_speed = 5
var velocity:Vector3 = Vector3(0, 0, 0)


func _ready():
	pass





func _physics_process(delta):
	velocity.y -= gravityy * delta
	velocity.y = clamp(velocity.y, - max_speed, 0)
	translate(velocity)


func _on_raindrop_body_entered(body):
	queue_free()
