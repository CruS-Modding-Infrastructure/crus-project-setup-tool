extends Spatial





var TIMER
var current_scene = 0
export  var walk = false
export (Array, String) var ANIMS
onready  var anim_player = $AnimationPlayer

func _ready():
	Global.player = self
	TIMER = get_parent().get_node("Timer")
	if ANIMS[current_scene] != "Hide":
		anim_player.play(ANIMS[current_scene])

func _process(delta):
	current_scene = get_parent().current_scene - 1
	if walk:
		translate(Vector3.FORWARD * delta)
	if ANIMS.size() > current_scene:
		if ANIMS[current_scene] == "Delete":
			queue_free()
			return 
		if ANIMS[current_scene] == "Hide":
			hide()
			return 
		else :
			show()
	if ANIMS.size() > current_scene:
		anim_player.play(ANIMS[current_scene])
	else :
		anim_player.play(ANIMS[ANIMS.size() - 1])



