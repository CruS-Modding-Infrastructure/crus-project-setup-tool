extends Viewport





export  var offset = 0


func _ready():
	$Weapon.rotation.y += deg2rad(offset)





func _process(delta):
	if not Global.menu.in_game:
		$Weapon.rotation.y += 1 * delta
