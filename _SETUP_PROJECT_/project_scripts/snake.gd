extends Spatial








func _ready():
	pass

func _physics_process(delta):
	$snake / AnimationPlayer.play("Idle", - 1, 0.2)
	look_at(Global.player.global_transform.origin, Vector3.UP)



