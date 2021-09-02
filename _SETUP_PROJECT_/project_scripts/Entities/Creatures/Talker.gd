extends Area





export  var line = "Wake up sheeple."


func _ready():
	pass





func player_use():
	Global.player.UI.message(line, true)
