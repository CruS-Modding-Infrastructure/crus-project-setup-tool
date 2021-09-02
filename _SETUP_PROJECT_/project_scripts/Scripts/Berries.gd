extends Area

export  var toxic = false
export  var healing = false
export  var healing_amount = 25
export  var kinematic = false






func _ready():
	pass

func player_use():
	if healing:
		Global.player.add_health(healing_amount)
		if kinematic:
			get_parent().queue_free()
		queue_free()
	if toxic:
		Global.player.set_toxic()
		queue_free()
	else :
		Global.player.detox()
		queue_free()



