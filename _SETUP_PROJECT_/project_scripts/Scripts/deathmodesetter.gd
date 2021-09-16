extends Area

func _ready():
	if Global.death:
		queue_free()

func _physics_process(delta):
	if Global.death:
		scale = scale.linear_interpolate(Vector3.ZERO, 0.2)

func player_use():
	Global.death = true
	Global.player.UI.health_texture.texture = Global.player.UI.DEATH
	Global.save_game()
	$CollisionShape.disabled = true
	$AudioStreamPlayer.play()
