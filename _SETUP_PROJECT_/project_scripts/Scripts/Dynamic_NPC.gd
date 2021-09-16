extends "res://Scripts/Stupid_Civilian.gd"



export  var level_range_min = 2
export  var level_range_max = 12

func _ready():
	print(Global.LEVELS_UNLOCKED)
	if level_range_max < Global.LEVELS_UNLOCKED or level_range_min > Global.LEVELS_UNLOCKED:
		get_parent().queue_free()
	yield (get_tree(), "idle_frame")
	if Global.hope_discarded:
		get_parent().damage(200, Vector3.ZERO, global_transform.origin, global_transform.origin)




