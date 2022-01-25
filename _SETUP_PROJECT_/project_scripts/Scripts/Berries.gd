extends Area

enum {SPEED, FLOATY, TOXIC, PSYCHOSIS, CANCER, GRAVITY}

export  var pills = false
export  var toxic = false
export  var healing = false
export  var healing_amount = 25
export  var kinematic = false

func _ready():
	pass

func player_use():
	if pills:
		match randi() % 6:
			SPEED:
				Global.player.drug_speed = 50
			FLOATY:
				Global.player.drug_slowfall = 150
			TOXIC:
				Global.player.set_toxic()
			PSYCHOSIS:
				Global.player.psychocounter = 200
			CANCER:
				Global.player.cancer_count = 9
				Global.player.cancer()
			GRAVITY:
				Global.player.drug_gravity_flag = true
		get_parent().get_node("AudioStreamPlayer3D").play()
		get_parent().visible = false
		Global.player.UI.notify("You ate pills.", Color(1, 0.0, 1.0))
		queue_free()
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



