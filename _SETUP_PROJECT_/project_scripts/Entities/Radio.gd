extends Area





var static_noise = 0
var current_track = 0


func _ready():
	current_track = randi() % Global.LEVEL_SONGS.size()
	$Radio.stream = Global.LEVEL_SONGS[current_track]
	$Radio.play()



func player_use():
	current_track += 1
	current_track = wrapi(current_track, 0, Global.LEVEL_SONGS.size())
	$Radio.stream = Global.LEVEL_SONGS[current_track]
	$Radio.play()
	
	
