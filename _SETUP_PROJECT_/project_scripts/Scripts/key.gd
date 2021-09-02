extends Area





export  var key_name = "Hotel Key"


func _ready():
	pass





func player_use():
	Global.player.key_found = true
	Global.player.UI.notify(key_name + " picked up", Color(0, 1, 0))
	get_parent().queue_free()
