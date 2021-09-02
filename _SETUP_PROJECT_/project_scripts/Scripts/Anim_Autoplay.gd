extends Spatial

func _ready():
	pass

func _physics_process(delta):
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("ArmatureAction")
