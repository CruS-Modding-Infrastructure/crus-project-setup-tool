extends Area








func _ready():
	pass







func _on_telepoorter_body_entered(body):
	
	if body == Global.player:
		body.player_velocity.y = 100
	else :
		body.velocity.y = 100
	$AudioStreamPlayer.play()
